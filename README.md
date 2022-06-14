# Datadog Audit Script
This script takes stock of all the active users in both Datadog and creates a CSV file with their name and email  


# How to use
1.) Initialize project

`bundle install`

2.) Add your Datadog **APP** and **API** keys to the `.env` file

3.) Run the following command with the appropriate region paramter to retreive datadog user information

`./datadog_audit.rb <region>`

**NOTE**: Enter either `US` or `EU` for the region parameter
