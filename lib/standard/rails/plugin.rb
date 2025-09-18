require "yaml"

module Standard
  module Rails
    class Plugin < LintRoller::Plugin
      def initialize(config)
        @config = config
        @merges_upstream_metadata = LintRoller::Support::MergesUpstreamMetadata.new
      end

      def about
        LintRoller::About.new(
          name: "standard-rails",
          version: VERSION,
          homepage: "https://github.com/testdouble/standard-rails",
          description: "Configuration for rubocop-rails rules"
        )
      end

      def supported?(context)
        true
      end

      def rules(context)
        trick_rubocop_into_thinking_we_required_rubocop_rails!

        LintRoller::Rules.new(
          type: :object,
          config_format: :rubocop,
          value: clean_rails_specific_parameters(
            without_extended_rule_configs(
              rules_with_config_applied
            )
          )
        )
      end

      private

      def rules_with_config_applied
        @merges_upstream_metadata.merge(
          YAML.load_file(Pathname.new(__dir__).join("../../../config/base.yml")).tap do |rules|
            if @config.key?("target_rails_version")
              rules["AllCops"]["TargetRailsVersion"] = @config["target_rails_version"]
            end
          end,
          YAML.load_file(Pathname.new(Gem.loaded_specs["rubocop-rails"].full_gem_path).join("config/default.yml"))
        )
      end

      # rubocop-rails adds additional options to a couple out-of-the-box cops
      # but Standard (1) doesn't enable these to begin with and (2) doesn't
      # allow rules' configs to be edited once they are defined, so we'll just
      # remove them here
      #
      # See: https://github.com/standardrb/standard-rails/issues/25#issuecomment-1881127173
      def without_extended_rule_configs(rules)
        rules.reject { |(name, _)|
          ["Style/InvertibleUnlessCondition", "Lint/SafeNavigationChain"].include?(name)
        }.to_h
      end

      # Clean up Rails-specific parameters that Standard doesn't support
      # to prevent warnings about unsupported parameters
      #
      # See: https://github.com/standardrb/standard-rails/issues/72
      def clean_rails_specific_parameters(rules)
        rules = rules.dup

        # Remove MigratedSchemaVersion from AllCops as it's Rails-specific
        if rules["AllCops"]
          rules["AllCops"] = rules["AllCops"].dup
          rules["AllCops"].delete("MigratedSchemaVersion")
        end

        # Clean up Lint/UselessAccessModifier - since it's disabled in base.yml,
        # we only need to keep the Enabled state and remove Rails-specific parameters
        if rules["Lint/UselessAccessModifier"]
          rules["Lint/UselessAccessModifier"] = {"Enabled" => false}
        end

        rules
      end

      # This is not fantastic.
      #
      # When you `require "rubocop-rails"`, it will not only load the cops,
      # but it will also monkey-patch RuboCop's default_configuration, which is
      # something that can't be undone for the lifetime of the process.
      #
      # See: https://github.com/rubocop/rubocop-rails/blob/master/lib/rubocop-rails.rb#L14
      #
      # As an alternative, standard-rails loads the cops directly, and then
      # simply tells the RuboCop config loader that it's been loaded. This is
      # taking advantage of a private API of an `attr_reader` that probably wasn't
      # meant to be mutated externally, but it's better than the `Inject` monkey
      # patching that rubocop-rails does (and many other RuboCop plugins do)
      def trick_rubocop_into_thinking_we_required_rubocop_rails!
        without_warnings do
          require_relative "load_rubocop_rails_without_the_monkey_patch"
        end
        RuboCop::ConfigLoader.default_configuration.loaded_features.add("rubocop-rails")
      end

      # This is also not fantastic, but because loading RuboCop before loading
      # ActiveSupport will result in RuboCop redefining a number of ActiveSupport
      # methods like String#blank?, we need to suppress the warnings that are
      # emitted when we load the cops.
      def without_warnings(&blk)
        original_verbose = $VERBOSE
        $VERBOSE = nil
        yield
      ensure
        $VERBOSE = original_verbose
      end
    end
  end
end
