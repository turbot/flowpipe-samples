mod "offboard_entra_id_users" {
  title         = "Offboard Entra ID Users"
  description   = "Suspend or disable accounts in Azure Active Directory after securing approval via Jira or email, and track all of the relevant information in a Jira ticket."
  documentation = file("./README.md")
  categories    = ["public cloud"]

  require {
    mod "github.com/turbot/flowpipe-mod-entra" {
      version = "v0.0.1-rc.5"
    }
    mod "github.com/turbot/flowpipe-mod-jira" {
      version = "v0.0.1-rc.8"
    }
  }
}
