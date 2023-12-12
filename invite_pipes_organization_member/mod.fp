mod "invite_pipes_organization_member" {
  title       = "Invite Pipes Organization Member"
  description = "Invite member via email, create a Pipes workspace, and add member to boost collaboration in your organization."
  categories  = ["access management"]

  opengraph {
    title       = "Invite Pipes Organization Member"
    description = "Invite member via email, create a Pipes workspace, and add member to boost collaboration in your organization."
  }

  require {
    mod "github.com/turbot/flowpipe-mod-pipes" {
      version = "v0.0.1-rc.7"
    }
  }
}
