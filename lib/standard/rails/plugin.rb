require "yaml"

module Standard
  module Rails
    class Plugin < LintRoller::Plugin
      def initialize(config)
        @config = config
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
          value: rules_with_config_applied
        )
      end

      private

      def rules_with_config_applied
        YAML.load_file(Pathname.new(__dir__).join("../../../config/base.yml")).tap do |rules|
          if @config.key?("target_rails_version")
            rules["AllCops"]["TargetRailsVersion"] = @config["target_rails_version"]
          end
        end
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
        require_relative "load_rubocop_rails_without_the_monkey_patch"
        RuboCop::ConfigLoader.default_configuration.loaded_features.add("rubocop-rails")
      end
    end
  end
end
