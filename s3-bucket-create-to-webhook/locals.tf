locals {
  aws_region            = "us-east-1"
  aws_account_id        = "012345678910"
  aws_profile_name      = "my-profile"
  topic_name            = "my_new_buckets"
  event_rule_name       = "aws_api_events_s3_create_bucket"
  subscription_endpoint = "https://MY-ENDPOINT"
  event_target_id       = "s3_create_bucket_event_handler"
}