//  Schedule Trigger
// trigger "schedule" "schedule_set_security_group" {
//   description = "A cron that checks xxxxx."
//   schedule    = "* * * * *"
//   // schedule    = "*/5 * * * *" // Run every 5 min
//   pipeline = pipeline.set_security_group
// }

// pipeline "set_security_group" {

//   param "token" {
//     type        = string
//     description = "API access token"
//     # TODO: Add once supported
//     # sensitive  = true
//     default = var.token
//   }

//   param "user_email" {
//     type        = string
//     description = "Email-id of the user."
//     default     = var.user_email
//   }

//   param "api_base_url" {
//     type        = string
//     description = "API base URL."
//     default     = var.api_base_url
//   }

//   param "project_key" {
//     type        = string
//     description = "The key identifying the project."
//     default     = var.project_key
//   }

//   step "pipeline" "list_issues" {
//     pipeline = jira.pipeline.list_issues
//     args = {
//       api_base_url = param.api_base_url
//       token        = param.token
//       user_email   = param.user_email
//       project_key  = param.project_key
//     }
//   }

//   step "pipeline" "describe_ec2_instances" {
//     depends_on = [step.pipeline.list_issues]
//     for_each   = step.pipeline.list_issues.output.issues.issues != null ? { for each_issue in step.pipeline.list_issues.output.issues.issues : each_issue.id => each_issue if strcontains(each_issue.fields.summary, "Update") } : tomap({})
//     pipeline   = aws.pipeline.describe_ec2_instances
//     args = {
//       region            = var.region
//       access_key_id     = var.access_key_id
//       secret_access_key = var.secret_access_key
//       instance_id       = split(" ", each.value.fields.summary)[1]
//       query             = "Reservations[*].Instances[*].[VpcId]"
//     }
//   }

//   output "describe_ec2_instances" {
//     value = step.pipeline.describe_ec2_instances
//   }
  // step "pipeline" "create_vpc_security_group" {
  //   depends_on = [step.pipeline.describe_ec2_instances]
  //   for_each   = step.pipeline.describe_ec2_instances != null ? { for each_instance in step.pipeline.describe_ec2_instances : each_instance.output.stdout[0][0][0] => each_instance.output.stdout[0][0][0]} : tomap({})
  //   pipeline   = aws.pipeline.create_vpc_security_group
  //   args = {
  //     region            = var.region
  //     access_key_id     = var.access_key_id
  //     secret_access_key = var.secret_access_key
  //     vpc_id            = each.value
  //     group_name        = "jira-security-group"
  //   }
  // }
  // step "pipeline" "modify_ec2_instance_attributes" {
  //   depends_on = [step.pipeline.list_issues]

  //   pipeline = aws.pipeline.modify_ec2_instance_attributes
  //   args = {
  //     instance_id = split(" ", each.value.fields.summary)[1]
  //     groups      = param.groups
  //   }
  // }

  // step "pipeline" "update_s3_bucket_public_access_block" {
  //   depends_on = [step.pipeline.list_issues]
  //   for_each = step.pipeline.list_issues.output.issues.issues != null ? { for each_issue in step.pipeline.list_issues.output.issues.issues : each_issue.id => each_issue if strcontains(each_issue.fields.summary, "Block")} : tomap({})
  //   pipeline = aws.pipeline.update_s3_bucket_public_access_block
  //   args = {
  //     region            = var.region
  //     access_key_id     = var.access_key_id
  //     secret_access_key = var.secret_access_key
  //     bucket            = split(" ", each.value.fields.summary)[1]
  //     public_access_block_configuration = "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
  //   }
  // }

// }