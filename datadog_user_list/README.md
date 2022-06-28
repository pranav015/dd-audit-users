# Datadog Script To Retrieve All Active Users
This script takes stock of all the active users in both Datadog regions and creates a CSV file with their name and email addresses 

# How to use
1.) Initialize project

`bundle install`

**NOTE**: Make sure you are in the right directory in your console
`cd datadog_user_list`

2.) Add your Datadog **APP** and **API** keys to the `.env` file

3.) Run the following command with the appropriate region paramter to retreive datadog user information

`./datadog_audit.rb <region>`

**NOTE**: Enter either `US` or `EU` for the region parameter

*if you get an error with running it, check to see if you have executable permissions enabled*
`chmod +x datadog_audit.rb`


