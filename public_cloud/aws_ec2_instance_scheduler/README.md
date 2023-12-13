# AWS EC2 Instance Scheduler

Starts and stops EC2 instances based on a schedule and notifies a Teams channel.

## Usage

- Set the AWS region to the `flowpipe.fpvars` file.
- Set the Team ID and the Teams channel ID to the `flowpipe.fpvars` file.
- Add the `schedule_name` tag to your EC2 instances with the name of the schedule you want to apply to the instance. Valid values are `business_hours`, `extended_business_hours`, `stop_for_night` and `stop_for_weekend`.
- Run Flowpipe mod as a server: `flowpipe server`
