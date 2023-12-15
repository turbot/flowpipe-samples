mod "invite_pipes_organization_member" {
  title         = "Invite Pipes Organization Member"
  description   = "Invite member via email, create a Pipes workspace, and add member to boost collaboration in your organization."
  documentation = file("./README.md")
  categories    = ["access management"]

  require {
    mod "github.com/turbot/flowpipe-mod-pipes" {
      version = "0.1.0"
    }
  }
}
