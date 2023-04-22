# standard-rails

This gem provides a [lint_roller](https://github.com/standardrb/lint_roller)
plugin configuration for the
[rubocop-rails](https://github.com/rubocop/rubocop-rails) ruleset, for use
as an extension to the [Standard Ruby
gem](https://github.com/standardrb/standard).

To install it, you'll want to start by adding it to your Gemfile:

```ruby
gem "standard-rails"
```

## Configuration

In your `.standard.yml` file, you can simply list `standard-rails` as a plugin:

```yaml
plugins:
  - standard-rails
```

Even though it'll usually be inferred automatically, you can specify the exact
version of Rails you want the rules to run against by converting the string to
a nested hash:

```yaml
plugins:
  - standard-rails:
      target_rails_version: 7.0
```

## Code of Conduct

This project follows Test Double's [code of
conduct](https://testdouble.com/code-of-conduct) for all community interactions,
including (but not limited to) one-on-one communications, public posts/comments,
code reviews, pull requests, and GitHub issues. If violations occur, Test Double
will take any action they deem appropriate for the infraction, up to and
including blocking a user from the organization's repositories.

