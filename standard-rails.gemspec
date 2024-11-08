require_relative "lib/standard/rails/version"

Gem::Specification.new do |spec|
  spec.name = "standard-rails"
  spec.version = Standard::Rails::VERSION
  spec.authors = ["Justin Searls"]
  spec.email = ["searls@gmail.com"]

  spec.summary = "A Standard plugin that adds Rails-specific rules to Standard"
  spec.homepage = "https://github.com/testdouble/standard-rails"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.metadata["default_lint_roller_plugin"] = "Standard::Rails::Plugin"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "lint_roller", "~> 1.0"
  spec.add_dependency "rubocop-rails", ">= 2.26", "< 2.28"
end
