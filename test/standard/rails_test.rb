require "test_helper"
require "rubocop"

class Standard::RailsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Standard::Rails::VERSION
  end

  BASE_CONFIG = "config/base.yml"
  INHERITED_OPTIONS = %w[
    Description
    Reference
    Safe
    SafeAutoCorrect
    StyleGuide
    VersionAdded
    VersionChanged
  ].freeze
  def test_configures_all_rails_cops
    expected = YAML.load_file(Pathname.new(Gem.loaded_specs["rubocop-rails"].full_gem_path).join("config/default.yml")).reject { |name, cop|
      ["Lint/NumberConversion", "Style/AndOr", "Style/FormatStringToken", "Style/SymbolProc", "Lint/RedundantSafeNavigation", "Style/InvertibleUnlessCondition", "Style/CollectionCompact"].include?(name)
    }.to_h
    actual = YAML.load_file(BASE_CONFIG)
    missing = (expected.keys - actual.keys).grep(/\//) # ignore groups like "Layout"
    extra = actual.keys - expected.keys - ["require"]
    if missing.any?
      puts "These cops need to be configured in `#{BASE_CONFIG}'. Defaults:"
      missing.each do |(name)|
        puts "\n#{name}:\n" + to_indented_yaml(expected[name], INHERITED_OPTIONS)
      end
    end

    assert_equal missing, [], "Configure these cops as either Enabled: true or Enabled: false in #{BASE_CONFIG}"
    assert_equal extra, [], "These cops do not exist and should not be configured in #{BASE_CONFIG}"
  end

  def test_does_not_require_rubocop_rails_and_change_the_default_rubocop_config
    @subject = Standard::Rails::Plugin.new({})

    @subject.rules(LintRoller::Context.new)

    assert defined?(RuboCop::Cop::Rails), "RuboCop::Cop::Rails not be defined (the cops aren't loaded and configuring them will blow up)"
    # Load *a* config to prove it's loaded, because #rules does not actually call RuboCop
    defaults = RuboCop::ConfigLoader.default_configuration
    assert(
      defaults.to_h.none? { |k, v| k.start_with?("Rails") },
      "Rails cops should not be injected into RuboCop defaults (someone is requiring `rubocop-rails`)"
    )
  end

  def test_alphabetized_config
    actual = YAML.load_file(BASE_CONFIG).keys - ["require"]
    expected = actual.sort

    assert_equal actual, expected, "Cop names should be alphabetized! (See this script to do it for you: https://github.com/testdouble/standard/pull/222#issue-744335213 )"
  end

  def test_merges_in_the_metadata_from_rubocop_performance
    owned_yaml = YAML.load_file(BASE_CONFIG)
    @subject = Standard::Rails::Plugin.new({})

    rules = @subject.rules(LintRoller::Context.new(target_ruby_version: RUBY_VERSION))

    assert_nil owned_yaml["Rails/ActionControllerFlashBeforeRender"]["Description"], "The description should be inherited from rubocop-rails"
    assert_equal "Use `ActionDispatch::IntegrationTest` instead of `ActionController::TestCase`.", rules.value["Rails/ActionControllerTestCase"]["Description"]
  end

  private

  def to_indented_yaml(cop_hash, without_keys = [])
    cop_hash.reject { |(k, v)|
      without_keys.include?(k)
    }.to_h.to_yaml.gsub(/^---\n/, "").gsub(/^/, "  ")
  end
end
