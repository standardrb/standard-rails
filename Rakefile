require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :copy_rubocop_rails_entry_point_and_comment_out_monkey_patch do
  gem_spec = Gem.loaded_specs["rubocop-rails"]
  gem_require_path = Pathname.new(gem_spec.full_require_paths.first)
  entry_point_contents = File.read(gem_require_path.join("rubocop-rails.rb"))
  already_printed_load_path_veriable = false
  entry_point_without_monkey_patch = entry_point_contents.split("\n").map { |line|
    if line.include?("Inject.defaults!") || line.include?("rails/inject")
      line.prepend("# ")
    elsif line.include?("require_relative")
      relative_path = line.match(/require_relative ['"](.*)['"]/)[1]

      if !already_printed_load_path_veriable
        already_printed_load_path_veriable = true
        [
          "require_path = Pathname.new(Gem.loaded_specs[\"rubocop-rails\"].full_require_paths.first)",
          "require require_path.join(#{relative_path.inspect})"
        ]
      else
        "require require_path.join(#{relative_path.inspect})"
      end
    else
      line
    end
  }.flatten.join("\n")

  File.write "lib/standard/rails/load_rubocop_rails_without_the_monkey_patch.rb", <<~RUBY
    # GENERATED FILE - DO NOT EDIT
    #
    # This file should look just like: https://github.com/rubocop/rubocop-rails/blob/master/lib/rubocop-rails.rb
    # Except without the `Inject.defaults!` monkey patching.
    #
    # Because there are both necessary require statements and additional patching
    # of RuboCop built-in cops in this file, we need to monitor it for changes
    # in rubocop-rails and keep it up to date.
    #
    # Last updated from #{gem_spec.name} v#{gem_spec.version}

    #{entry_point_without_monkey_patch}
  RUBY
end

require "standard/rake"

task default: %i[copy_rubocop_rails_entry_point_and_comment_out_monkey_patch standard:fix test]
