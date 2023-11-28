pipeline "add_event_to_google_calender" {
  title       = "Add Google Calendar Event"
  description = "Add a event to Google Calendar."

  param "access_token" {
    type        = string
    description = "Access tokens are used for authentication in googleworkspace."
    default     = var.access_token
  }

  param "calendar_id" {
    type        = string
    description = "The calender ID."
  }

  param "time_zone" {
    type        = string
    description = "The time zone in which the time is specified."
  }

  param "start_date_time" {
    type        = string
    description = "The start dateTime."
  }

  param "end_date_time" {
    type        = string
    description = "The end dateTime."
  }

  param "summary" {
    type        = string
    description = "Title of the event."
    optional    = true
  }

  param "description" {
    type        = string
    description = "Description of the event."
    optional    = true
  }

  param "location" {
    type        = string
    description = "Geographic location of the event as free-form text."
    optional    = true
  }

  param "attendees_email" {
    type        = list(string)
    description = "The attendee's email address."
    optional    = true
  }

  step "pipeline" "add_calender_event" {
    pipeline = googleworkspace.pipeline.add_calender_event
    args = {
      access_token    = param.access_token
      calendar_id     = param.calendar_id
      time_zone       = param.time_zone
      start_date_time = param.start_date_time
      end_date_time   = param.end_date_time
      summary         = param.summary
      description     = param.description
      location        = param.location
      attendees_email = param.attendees_email
    }
  }

  output "add_calender_event" {
    description = "The calender event."
    value       = step.pipeline.add_calender_event.output.add_calender_event
  }
}