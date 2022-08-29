# Datadog Script To Remove Users Listed in CSV file
This script disables the Datadog accounts of all users listed in a CSV file

# How to use
Step 1: Create a new csv file with the following filename `users-to-remove-<region>.csv` where region is `us` or `eu`

**NOTE**: The CSV file must only include the email addresses of the users to be disabled (no header included) 
Example csv file format:
```
emailone@zendesk.com
emailtwo@zendesk.com
.
.
.
emailten@zendesk.com
```

# How to use
Step 2: Initialize the project

Run the following command:
`bundle install`

**NOTE**: Make sure you are in the <strong>remove_users<strong> directory in your console
`cd remove_users`

2.) Add your Datadog **APP** and **API** keys to the `.env` file

3.) Run the following command with the appropriate region paramter to retreive datadog user information

`./remove_users.rb <region>`

**NOTE**: Enter either `us` or `eu` for the region parameter

*if you get an error trying to run the script, check to see if you have executable permissions enabled*
`chmod +x remove_users.rb`
