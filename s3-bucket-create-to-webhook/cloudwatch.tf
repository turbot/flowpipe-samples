resource "aws_cloudwatch_event_rule" "aws_api_events_s3" {
  name        = local.event_rule_name
  description = "Capture AWS API events for s3:CreateBucket"
  event_pattern = jsonencode({
    detail = {
      "eventName" = ["CreateBucket"]
    },
    "source" = ["aws.s3"],
    "detail-type" = ["AWS API Call via CloudTrail"]
  })
}

resource "aws_cloudwatch_event_target" "aws_api_events_s3" {
  rule      = aws_cloudwatch_event_rule.aws_api_events_s3.name
  arn       = aws_sns_topic.aws_api_handler.arn
  target_id = local.event_target_id
}