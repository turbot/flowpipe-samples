resource "aws_sns_topic" "aws_api_handler" {
  name = local.topic_name
}

resource "aws_sns_topic_subscription" "aws_api_handler" {
  topic_arn               = aws_sns_topic.aws_api_handler.arn
  protocol                = "https"
  endpoint                = local.subscription_endpoint
  endpoint_auto_confirms  = true
}

resource "aws_sns_topic_policy" "aws_api_handler" {
  arn    = aws_sns_topic.aws_api_handler.arn
  policy = data.aws_iam_policy_document.aws_api_handler.json
}