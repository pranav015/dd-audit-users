# Datadog Audit Script
This script takes stock of all the active users in both Datadog and creates a CSV file with their name and email  


# How to use
Initialize project

`bundle install`

Run the follwoing command with the region paramter to retreive datadog user information for that region

**NOTE**: enter `US` or `EU` for the region

`./datadog_audit.rb <region>`
