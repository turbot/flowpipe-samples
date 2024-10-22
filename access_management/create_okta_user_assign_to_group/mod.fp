mod "create_okta_user_assign_to_group" {
  title         = "Create Okta User and Assign to Group"
  description   = "Create a user in Okta and assign to a group."
  documentation = file("./README.md")
  categories    = ["access management", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-okta" {
      version = "^1"
    }
  }
}
