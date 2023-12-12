# Remediate AWS Guard Duty Alerts

Automate AWS SNS notifications from Guard Duty Findings triggering Jira issue creation, execute actions in AWS for identified issues, and update issue state to "done" upon resolution.AWS GuardDuty alerts based on different event types triggered.

## Usage

- Set your `JIRA_API_TOKEN`, `JIRA_URL`, `JIRA_USER` environment variables or configure your Jira credentials in `~/.flowpipe/config/jira.fpc`:
  ```hcl
  credential "jira" "jira_cred" {
    base_url    = "https://test.atlassian.net/"
    api_token   = "ATATT3........."
    username    = "abc@email.com"
  }
  ```

- Set your `AWS_PROFILE`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` environment variables or configure your Jira credentials in `~/.flowpipe/config/aws.fpc`:
  ```hcl
  credential "aws" "aws_profile" {
    profile = "my-profile"
  }

  credential "aws" "aws_access_key_pair" {
    access_key = "AKIA..."
    secret_key = "dP+C+J..."
  }

  credential "aws" "aws_session_token" {
    access_key = "AKIA..."
    secret_key = "dP+C+J..."
    session_token = "AQoDX..."
  }
  ```

- Run the pipeline and specify 

