# Datadog Script To Remove Users Listed in CSV file
This script disables the Datadog accounts of all users listed in a CSV file

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
1.) Initialize project

`bundle install`

**NOTE**: Make sure you are in the right directory in your console
`cd remove_users`

2.) Add your Datadog **APP** and **API** keys to the `.env` file

3.) Create a csv files with the following name (make sure the file ends with `-us` or `-eu`)
`users-to-remove-us.csv` For DD US users
`users-to-remove-eu.csv` For DD EU users

4.) Run the following command with the appropriate region paramter to retreive datadog user information

`./remove_users.rb <region>`

**NOTE**: Enter either `US` or `EU` for the region parameter

*if you get an error trying to run the script, check to see if you have executable permissions enabled*
`chmod +x remove_users.rb`
