require "test_helper"

module Standard::Rails
  class PluginTest < Minitest::Test
    def setup
    end

    def test_default_configuration
      subject = Plugin.new({})

      result = subject.rules(LintRoller::Context.new)

      assert_equal(LintRoller::Rules.new(
        type: :object,
        config_format: :rubocop,
        value: YAML.load_file(Pathname.new(__dir__).join("../../../config/base.yml"))
      ), result)
    end

    def test_configuring_target_rails_version
      subject = Plugin.new(({"target_rails_version" => 5.2}))

      result = subject.rules(LintRoller::Context.new)

      assert_equal 5.2, result.value["AllCops"]["TargetRailsVersion"]
    end
  end
end
