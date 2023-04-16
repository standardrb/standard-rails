# standard-rails

This gem provides a [lint_roller](https://github.com/standardrb/lint_roller)
plugin configuration for the
[rubocop-rails](https://github.com/rubocop/rubocop-rails) ruleset, for use
as an extension to the [Standard Ruby
gem](https://github.com/standardrb/standard).

## Configuration

If you're using Standard, the plugin is configured in your `.standard.yml` as a
hash that nests beneath the `standard-rails` array element:

```yaml
plugins:
  standard-rails:
    target_rails_version: 7.0
```

## Code of Conduct

This project follows Test Double's [code of
conduct](https://testdouble.com/code-of-conduct) for all community interactions,
including (but not limited to) one-on-one communications, public posts/comments,
code reviews, pull requests, and GitHub issues. If violations occur, Test Double
will take any action they deem appropriate for the infraction, up to and
including blocking a user from the organization's repositories.

