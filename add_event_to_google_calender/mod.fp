mod "add_event_to_google_calender" {
  title       = "Add Google Calendar Event"
  description = "Add a event to Google Calendar."

  require {
    mod "github.com/turbot/flowpipe-mod-googleworkspace" {
      version = "v0.0.1-rc.5"
      args = {
        access_token = var.access_token
      }
    }
  }
}
