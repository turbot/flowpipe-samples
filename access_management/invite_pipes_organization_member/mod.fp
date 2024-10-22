mod "invite_pipes_organization_member" {
  title         = "Invite Pipes Organization Member"
  description   = "Invite member via email, create a Pipes workspace, and add member to boost collaboration in your organization."
  documentation = file("./README.md")
  categories    = ["access management", "sample"]

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-pipes" {
      version = "^1"
    }
  }
}
