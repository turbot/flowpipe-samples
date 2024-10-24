## v1.0.0 (2024-10-22)

The following changes have been made for all sample mods:

_Breaking changes_

- Flowpipe v1.0.0 is now required. For a full list of CLI changes, please see the [Flowpipe v1.0.0 CHANGELOG](https://flowpipe.io/changelog/flowpipe-cli-v1-0-0).
- In Flowpipe configuration files (`.fpc`), `credential` and `credential_import` resources have been renamed to `connection` and `connection_import` respectively.
- Updated the following param types:
  - `approvers`: `list(string)` to `list(notifier)`.
  - `database`: `string` to `connection.steampipe`.
  - `notifier`: `string` to `notifier`.
- Updated the following variable types:
  - `approvers`: `list(string)` to `list(notifier)`.
  - `database`: `string` to `connection.steampipe`.
  - `notifier`: `string` to `notifier`.
- Renamed `cred` param to `conn` and updated its type from `string` to `conn`.

_Enhancements_

- Added `sample` to each mod's categories.
- Updated the following pipeline tags:
  - `type = "featured"` to `recommended = "true"`
- Added `format` to params and variables that use multiline and JSON strings.

## v0.4.1 [2024-03-05]

_Bug fixes_

- Fixed broken links to credential import docs in various sample READMEs.

## v0.4.0 [2024-03-05]

_What's new?_

- Added the following new sample mods: ([#108](https://github.com/turbot/flowpipe-samples/pull/108))
  - `add_s3_bucket_cost_center_tags`
  - `aws_iam_access_key_events_notifier_with_multiple_pipelines`
  - `aws_iam_access_key_events_notifier_with_single_pipeline`
  - `deactivate_expired_aws_iam_access_keys_using_queries`
  - `deactivate_expired_aws_iam_access_keys_with_approval`
  - `notify_new_aws_iam_access_keys`

_Enhancements_

- Updated all AWS, Azure, PagerDuty, Slack, Zendesk library mod dependency versions in several sample mods. ([#108](https://github.com/turbot/flowpipe-samples/pull/108))

## v0.3.0 [2024-01-12]

_What's new?_

- Added the `query_and_stop_aws_ec2_instances_by_tag` sample mod that can be used with Flowpipe. ([#99](https://github.com/turbot/flowpipe-samples/pull/99))

_Bug fixes_

- Fixed the README docs to use `--arg` instead of `--pipeline-arg` as the argument flag. ([#102](https://github.com/turbot/flowpipe-samples/pull/102))
- Fixed the link for installing mod dependencies in all the README docs. ([#98](https://github.com/turbot/flowpipe-samples/pull/98))

## v0.2.0 [2023-12-15]

_Bug fixes_

- Added missing `categories` and `documentation` args to several mods.

## v0.1.0 [2023-12-13]

_What's new?_

- Added 35+ sample mods that can be used with Flowpipe. For usage information and a full list of mods, please see [Flowpipe Hub](https://hub.flowpipe.io/?type=sample#search).
