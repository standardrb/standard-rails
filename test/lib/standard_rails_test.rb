require "test_helper"

class StandardRailsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Standard::Rails::VERSION
  end
end
