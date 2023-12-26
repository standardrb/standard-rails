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
  end
end
