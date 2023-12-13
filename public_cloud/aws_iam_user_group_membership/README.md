# AWS IAM User Group Membership

This composite module performs a daily check at 9 AM UTC for AWS IAM users belonging to multiple groups. It creates or updates GitHub issues for each user found in this situation.

## Usage

- Add your AWS, GitHub API keys to `flowpipe.fpvars`
- This mod runs a daily cron job using Triggers, but if you wish to run the pipeline manually then use `flowpipe pipeline run aws_iam_user_group_membership`

Example: When a GitHub issue already exists for a user with multiple groups assigned, update the issue.

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

- When Github Issue does not exists, for a user with multiple groups assigned, create a new one.

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

- When GitHub Issue exists for a user who no longer has multiple groups assigned, close the issue.

```json
{
  "flowpipe": {
    "execution_id": "exec_claun40cj6rh7f76itq0",
    "pipeline_execution_id": "pexec_claun40cj6rh7f76itqg",
    "status": "finished"
  },
  "github_close_issue": {
    "krishna": {
      "issue": {
        "id": "I_kwDOKdfEDM53AGnN",
        "url": "https://github.com/vkumbha/deleteme/issues/39"
      }
    },
    "raj": {
      "issue": {
        "id": "I_kwDOKdfEDM52brQj",
        "url": "https://github.com/vkumbha/deleteme/issues/28"
      }
    },
    "venu": {}
  },
  "github_comment_issue": {
    "krishna": {},
    "raj": {},
    "venu": {
      "issue_comment": {
        "body": "Date: 2023-11-16T10:14:47Z\nThe IAM groups assigned to user 'venu' are: readonly, Admin.",
        "id": "IC_kwDOKdfEDM5sIb8I",
        "issue": {
          "id": "I_kwDOKdfEDM52OyGO",
          "url": "https://github.com/vkumbha/deleteme/issues/16"
        },
        "url": "https://github.com/vkumbha/deleteme/issues/16#issuecomment-1814150920"
      }
    }
  },
  "github_create_issue": {
    "krishna": {},
    "raj": {},
    "venu": {}
  },
  "github_search_issue": {
    "krishna": {
      "issues": [
        {
          "createdAt": "2023-11-16T10:14:14Z",
          "number": 39,
          "repository": {
            "name": "deleteme"
          },
          "title": "[AWS IAM User in Groups]: User 'krishna' is assigned with 2 IAM groups.",
          "url": "https://github.com/vkumbha/deleteme/issues/39"
        }
      ]
    },
    "raj": {
      "issues": [
        {
          "createdAt": "2023-11-10T06:00:07Z",
          "number": 28,
          "repository": {
            "name": "deleteme"
          },
          "title": "[AWS IAM User in Groups]: User 'raj@turbot.com' is assigned with 2 IAM groups.",
          "url": "https://github.com/vkumbha/deleteme/issues/28"
        },
        {
          "createdAt": "2023-11-10T06:00:06Z",
          "number": 21,
          "repository": {
            "name": "deleteme"
          },
          "title": "[AWS IAM User in Groups]: User 'raj@turbot.com' is assigned with 2 IAM groups.",
          "url": "https://github.com/vkumbha/deleteme/issues/21"
        }
      ]
    },
    "venu": {
      "issues": [
        {
          "createdAt": "2023-11-08T13:12:54Z",
          "number": 16,
          "repository": {
            "name": "deleteme"
          },
          "title": "[AWS IAM User in Groups]: User 'venu' is assigned with 2 IAM groups.",
          "url": "https://github.com/vkumbha/deleteme/issues/16"
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
