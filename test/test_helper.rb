$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
begin
  require "simplecov"
  SimpleCov.start do
    load_profile "test_frameworks"
  end
rescue LoadError
end

require "standard/rails"

require "minitest/autorun"
