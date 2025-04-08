# standard-rails

This gem provides a [lint_roller](https://github.com/standardrb/lint_roller)
plugin configuration for the
[rubocop-rails](https://github.com/rubocop/rubocop-rails) ruleset, for use
as an extension to the [Standard Ruby
gem](https://github.com/standardrb/standard).

## Usage

First, if you haven't already, get your app set up to [run with the `standard` 
gem](https://github.com/standardrb/standard#usage)

Next, to add the `standard-rails` plugin, you'll want to start by adding it to your Gemfile:

```ruby
gem "standard-rails", group: [:development, :test]
```

Next, in your [`.standard.yml` file](https://github.com/standardrb/standard#yaml-options), 
list `standard-rails` as a plugin:

```yaml
plugins:
  - standard-rails
```

## Configuration

Even though it'll usually be inferred automatically, you can specify the exact
version of Rails you want the rules to be run against like this:

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

