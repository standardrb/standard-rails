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

    def test_removes_migrated_schema_version_from_all_cops
      subject = Plugin.new({})

      result = subject.rules(LintRoller::Context.new)

      refute result.value["AllCops"].key?("MigratedSchemaVersion"),
        "AllCops should not contain MigratedSchemaVersion parameter"
    end

    def test_cleans_up_lint_useless_access_modifier
      subject = Plugin.new({})

      result = subject.rules(LintRoller::Context.new)

      assert_equal({"Enabled" => false}, result.value["Lint/UselessAccessModifier"],
        "Lint/UselessAccessModifier should only have Enabled parameter")
      refute result.value["Lint/UselessAccessModifier"].key?("ContextCreatingMethods"),
        "Lint/UselessAccessModifier should not contain ContextCreatingMethods parameter"
      refute result.value["Lint/UselessAccessModifier"].key?("inherit_mode"),
        "Lint/UselessAccessModifier should not contain inherit_mode parameter"
    end
  end
end
