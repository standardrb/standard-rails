require "test_helper"

module Standard::Rails
  class PluginTest < Minitest::Test
    def setup
    end

    def test_configuring_target_rails_version
      subject = Plugin.new({"target_rails_version" => 5.2})

      result = subject.rules(LintRoller::Context.new)

      assert_equal 5.2, result.value["AllCops"]["TargetRailsVersion"]
    end

    def test_filters_migrated_schema_version_from_all_cops
      subject = Plugin.new({})

      result = subject.rules(LintRoller::Context.new)

      refute_includes result.value.fetch("AllCops", {}).keys, "MigratedSchemaVersion"
    end

    def test_removes_useless_access_modifier_block
      subject = Plugin.new({})

      result = subject.rules(LintRoller::Context.new)

      assert_nil result.value["Lint/UselessAccessModifier"]
    end

    def test_removes_useless_method_definition_block
      subject = Plugin.new({})

      result = subject.rules(LintRoller::Context.new)

      assert_nil result.value["Lint/UselessMethodDefinition"]
    end

    def test_no_parameter_warnings_when_validating_config
      subject = Plugin.new({})
      rules = subject.rules(LintRoller::Context.new)

      _, err = capture_io do
        RuboCop::Config.create(rules.value, "inline.yml", check: true)
      end

      assert_equal "", err
    end
  end
end
