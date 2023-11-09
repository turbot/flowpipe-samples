# AWS IAM User in Groups

A composite mod that runs a daily cron job at 9 AM UTC to check for AWS IAM users with multiple group assignments, creates issues in Github. List IAM Users associated with more than a Group. Create a GitHub issue for User if there isn't one already. If an issue is already present then update the same."

## Usage

- Add your AWS, GitHub API keys to `flowpipe.pvars`
- This mod runs a daily cron job using Triggers, but if you wish to run the pipeline manually then use `flowpipe pipeline run aws_iam_user_in_groups`

Example: When a GitHub issue already exists

```json
{
  "flowpipe": {
    "execution_id": "exec_cl5oi28cj6rv82vo1540",
    "pipeline_execution_id": "pexec_cl5oi28cj6rv82vo154g",
    "status": "finished"
  },
  "github_create_issue": {
    "krishna": {},
    "raj": {},
    "venu": {}
  },
  "github_comment_issue": {
    "krishna": {},
    "raj": {},
    "venu": {
      "issue": {
        "id": "I_kwDOKdfEDM52M872",
        "url": "https://github.com/vkumbha/deleteme/issues/15"
      }
    }
  },
  "github_search_issue": {
    "krishna": {
      "issues": null
    },
    "raj": {
      "issues": null
    },
    "venu": {
      "issues": [
        {
          "createdAt": "2023-11-08T09:10:51Z",
          "number": 15,
          "repository": {
            "name": "deleteme"
          },
          "title": "[AWS IAM User in Groups]: User 'venu' is assigned with 2 IAM groups.",
          "url": "https://github.com/vkumbha/deleteme/issues/15"
        }
      ]
    }
  },
  "iam_groups_for_users": {
    "krishna": {
      "Groups": null
    },
    "raj": {
      "Groups": [
        {
          "Arn": "arn:aws:iam::123456789012:group/readonly",
          "CreateDate": "2023-10-19T07:27:58+00:00",
          "GroupId": "AGPA5LT56WANH7FJS4BRO",
          "GroupName": "readonly",
          "Path": "/"
        }
      ]
    },
    "venu": {
      "Groups": [
        {
          "Arn": "arn:aws:iam::123456789012:group/readonly",
          "CreateDate": "2023-10-19T07:27:58+00:00",
          "GroupId": "AGPA5LT56WANH7FJS4BRO",
          "GroupName": "readonly",
          "Path": "/"
        },
        {
          "Arn": "arn:aws:iam::123456789012:group/Admin",
          "CreateDate": "2020-12-14T16:24:00+00:00",
          "GroupId": "AGPA5LT56WANIDXRLKR7N",
          "GroupName": "Admin",
          "Path": "/"
        }
      ]
    }
  },
  "iam_users": {
    "Users": [
      {
        "Arn": "arn:aws:iam::123456789012:user/krishna",
        "CreateDate": "2023-11-08T12:50:53+00:00",
        "Path": "/",
        "UserId": "AIDA5LT56WAND6DW4J2HC",
        "UserName": "krishna"
      },
      {
        "Arn": "arn:aws:iam::123456789012:user/raj",
        "CreateDate": "2023-11-08T12:50:44+00:00",
        "Path": "/",
        "UserId": "AIDA5LT56WANAZQJFKI4A",
        "UserName": "raj"
      },
      {
        "Arn": "arn:aws:iam::123456789012:user/venu",
        "CreateDate": "2023-11-08T12:50:28+00:00",
        "Path": "/",
        "UserId": "AIDA5LT56WANIOIZWYD5U",
        "UserName": "venu"
      }
    ]
  }
}
```

- When Github Issue does not exists, create a new one.

```json
{
  "flowpipe": {
    "execution_id": "exec_cl5oii0cj6rv82vo16a0",
    "pipeline_execution_id": "pexec_cl5oii0cj6rv82vo16ag",
    "status": "finished"
  },
  "github_create_issue": {
    "krishna": {},
    "raj": {},
    "venu": {
      "issue": {
        "id": "I_kwDOKdfEDM52OyGO",
        "url": "https://github.com/vkumbha/deleteme/issues/16"
      }
    }
  },
  "github_comment_issue": {
    "krishna": {},
    "raj": {},
    "venu": {}
  },
  "github_search_issue": {
    "krishna": {
      "issues": null
    },
    "raj": {
      "issues": null
    },
    "venu": {
      "issues": null
    }
  },
  "iam_groups_for_users": {
    "krishna": {
      "Groups": null
    },
    "raj": {
      "Groups": [
        {
          "Arn": "arn:aws:iam::123456789012:group/readonly",
          "CreateDate": "2023-10-19T07:27:58+00:00",
          "GroupId": "AGPA5LT56WANH7FJS4BRO",
          "GroupName": "readonly",
          "Path": "/"
        }
      ]
    },
    "venu": {
      "Groups": [
        {
          "Arn": "arn:aws:iam::123456789012:group/readonly",
          "CreateDate": "2023-10-19T07:27:58+00:00",
          "GroupId": "AGPA5LT56WANH7FJS4BRO",
          "GroupName": "readonly",
          "Path": "/"
        },
        {
          "Arn": "arn:aws:iam::123456789012:group/Admin",
          "CreateDate": "2020-12-14T16:24:00+00:00",
          "GroupId": "AGPA5LT56WANIDXRLKR7N",
          "GroupName": "Admin",
          "Path": "/"
        }
      ]
    }
  },
  "iam_users": {
    "Users": [
      {
        "Arn": "arn:aws:iam::123456789012:user/krishna",
        "CreateDate": "2023-11-08T12:50:53+00:00",
        "Path": "/",
        "UserId": "AIDA5LT56WAND6DW4J2HC",
        "UserName": "krishna"
      },
      {
        "Arn": "arn:aws:iam::123456789012:user/raj",
        "CreateDate": "2023-11-08T12:50:44+00:00",
        "Path": "/",
        "UserId": "AIDA5LT56WANAZQJFKI4A",
        "UserName": "raj"
      },
      {
        "Arn": "arn:aws:iam::123456789012:user/venu",
        "CreateDate": "2023-11-08T12:50:28+00:00",
        "Path": "/",
        "UserId": "AIDA5LT56WANIOIZWYD5U",
        "UserName": "venu"
      }
    ]
  }
}
```
