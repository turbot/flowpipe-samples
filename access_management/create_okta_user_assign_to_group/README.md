# Create Okta User and Assign to Group

Create a user in Okta and assign to a group.

## Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-samples.git
cd access_management/create_okta_user_assign_to_group
```

[Install mod dependencies](https://flowpipe.io/docs/build/mod-dependencies#mod-dependencies):

```sh
flowpipe mod install
```

## Connections

By default, the following environment variables will be used for authentication:

- `OKTA_TOKEN`
- `OKTA_ORGURL`

You can also create `connection` resources in configuration files:

```sh
vi ~/.flowpipe/config/okta.fpc
```

```hcl
connection "okta" "default" {
  domain    = "https://test.okta.com"
  api_token = "00B63........"
}
```

For more information on connections in Flowpipe, please see [Managing Connections](https://flowpipe.io/docs/run/connections).

## Usage

Run the pipeline and specify the `first_name`, `last_name`, `email`, `login`, `password` and `group_id` pipeline arguments:

```sh
flowpipe pipeline run create_okta_user_assign_to_group \
  --arg first_name='Foo' \
  --arg last_name='Bar' \
  --arg email='foo.bar@baz.com' \
  --arg login='foo.bar' \
  --arg password='password' \
  --arg group_id='00g1x2x3x4x5x6x7x8x9'
```