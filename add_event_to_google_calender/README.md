# Add Google Calendar Event

Add a event to Google Calendar.

## Usage

- Run `flowpipe mod install --git-url-mode ssh` to add the dependencies.
- Add your Googleworkspace Access Token to `flowpipe.pvars`. To generate the token, please refer to the [Google Cloud SDK documentation](https://cloud.google.com/sdk/gcloud/reference/auth/print-access-token).
- Run the pipeline and specify `calendar_id`, `time_zone`, `start_date_time` and `end_date_time`, e.g., `flowpipe pipeline run add_calender_event --arg 'calendar_id=foo@example.com' --arg 'time_zone=Asia/Kolkata' --arg 'start_date_time=2015-05-28T09:00:00' --arg 'end_date_time=2015-05-28T10:00:00'`
- You can also specify the `--arg summary=test`, `--arg description=test`, `--arg location=Kolkata` and `--arg attendees_email=[test@gmail.com]`
