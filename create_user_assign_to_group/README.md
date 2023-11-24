# Create a user in Okta and assign to a group

Create a user in Okta and assign to a group.

## Usage

- Add following required credentials to `flowpipe.fpvars`
  - Okta domain and API token

- Start your Flowpipe server `flowpipe server`

- Create a user in Okta and add to a group. This step is an independent pipeline to create user and assign to a group e.g.

  ```
  flowpipe pipeline run create_user_assign_to_group  --arg first_name='Foo' --arg last_name='Bar' --arg email='foo.bar@baz.com' --arg login='foo.bar' --arg password='password' --arg group_id='00g1x2x3x4x5x6x7x8x9'
  ```
