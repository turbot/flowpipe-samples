mod "add_pipes_org_workspace_invite_members" {
  title       = "Add Pipes Organization to Invite Members"
  description = "Add organization in pipe and invite members to join by email."

  require {
    mod "github.com/turbot/flowpipe-mod-pipes" {
      version = "v0.0.1-rc.3"
      args = {
        token = var.token
      }
    }
  }
}
