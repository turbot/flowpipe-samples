# Add User to Multiple Services

Adds a user to multiple services.

## Usage

- Add your services API keys / tokens to `flowpipe.pvars`
- Start your Flowpipe server
- Run the pipeline e.g., `flowpipe pipeline run add_user_to_multiple_services --pipeline-arg user_email=my_new_user@email.com --pipeline-arg services=['github', 'okta']`
