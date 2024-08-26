# GENERATED FILE - DO NOT EDIT
#
# This file should look just like: https://github.com/rubocop/rubocop-rails/blob/master/lib/rubocop-rails.rb
# Except without the `Inject.defaults!` monkey patching.
#
# Because there are both necessary require statements and additional patching
# of RuboCop built-in cops in this file, we need to monitor it for changes
# in rubocop-rails and keep it up to date.
#
# Last updated from rubocop-rails v2.26.0

# frozen_string_literal: true

require "rubocop"
require "rack/utils"
require "active_support/inflector"
require "active_support/core_ext/object/blank"

require_path = Pathname.new(Gem.loaded_specs["rubocop-rails"].full_require_paths.first)
require require_path.join("rubocop/rails")
require require_path.join("rubocop/rails/version")
# require_relative 'rubocop/rails/inject'
require require_path.join("rubocop/rails/schema_loader")
require require_path.join("rubocop/rails/schema_loader/schema")

# RuboCop::Rails::Inject.defaults!

require require_path.join("rubocop/cop/rails_cops")

RuboCop::Cop::Style::HashExcept.minimum_target_ruby_version(2.0)

RuboCop::Cop::Style::InverseMethods.singleton_class.prepend(
  Module.new do
    def autocorrect_incompatible_with
      super.push(RuboCop::Cop::Rails::NegateInclude)
    end
  end
)

RuboCop::Cop::Style::MethodCallWithArgsParentheses.singleton_class.prepend(
  Module.new do
    def autocorrect_incompatible_with
      super.push(RuboCop::Cop::Rails::EagerEvaluationLogMessage)
    end
  end
)

RuboCop::Cop::Style::RedundantSelf.singleton_class.prepend(
  Module.new do
    def autocorrect_incompatible_with
      super.push(RuboCop::Cop::Rails::SafeNavigation)
    end
  end
)
