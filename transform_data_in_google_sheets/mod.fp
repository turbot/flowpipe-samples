mod "send_top_show_hn_email" {
  title       = "Send top 'Show HN' Email"
  description = "Send an email using SendGrid containing top stories from 'Show HN'."

  require {
    mod "github.com/turbot/flowpipe-mod-googleworkspace" {
      version = "0.0.1-rc.0"
      args = {
        code          = var.code
        client_id     = var.client_id
        client_secret = var.client_secret
        access_token  = var.access_token
      }
    }
  }
}


// code="4/0AfJohXkXoFtU04sI2yP1NToQ5h2PHeiJsjEb3LJEgcRKSbnWg1zL4vvJCV8u9Pz2xQji3Q"
// client_id="979620418102-okqtslbrgpsvspnu0040b8n8a1voiqo0.apps.googleusercontent.com"
// client_secret="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"
// access_token="ya29.a0AfB_byCZuOBFJY-TIRfla-_Ya0HNC5aSM-Zwqx1dU4XYKllFpijYT0k7NO3l7tbnPed2jIHiEyrZNSfui7DU9DHBh4bo8yRtTnGK2L3OJxiRtWBUc16s7lEU3mKcdyxl2ROlZg7v1SWGNwC2D7QBKE-4Kkn8xB2j9iiraCgYKAUQSARISFQHGX2Mi-kC-fZK1s4V56VXHUAgnbA0171"