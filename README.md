# Datadog Audit Script
This script takes stock of all the active users in both Datadog and creates a CSV file with their name and email  


# How to use
1.) Initialize project

`bundle install`

2.) Add your Datadog APP and API keys to the .env file

3.) Run the follwoing command with the region paramter to retreive datadog user information for that region

`./datadog_audit.rb <region>`

**NOTE**: enter `US` or `EU` for the region
