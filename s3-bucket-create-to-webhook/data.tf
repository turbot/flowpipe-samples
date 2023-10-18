data "aws_iam_policy_document" "aws_api_handler" {
  statement {
    sid    = "AllowCloudWatchEventsToPublish"
    effect = "Allow"

    actions = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.aws_api_handler.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:events:${local.aws_region}:${local.aws_account_id}:rule/*"]
    }
  }

  statement {
    sid    = "AllowPublishThroughSSLOnly"
    effect = "Deny"

    actions    = ["sns:Publish"]
    resources  = [aws_sns_topic.aws_api_handler.arn]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}