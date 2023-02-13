## Datadog Script To Retrieve All Active Users
This script takes stock of all the active, disabled, and pending user accounts in both Datadog regions and creates a CSV file with their name, email addresses, and other relevant info 

# How to run
1.) Initialize project

`bundle install`

**NOTE**: Make sure you are in the right directory in your console
`cd datadog_user_list`

2.) Add your Datadog **APP** and **API** keys to the `.env` file

3.) Run the following command with the appropriate region paramter to retreive datadog user information

`./datadog_audit.rb <region>`

**NOTE**: Enter either `US` or `EU` for the region parameter

The script will write all the generated user reports to the "output" folder

*if you get an error when trying to run the script, check to see if you have executable permissions enabled*
`chmod +x datadog_audit.rb`
