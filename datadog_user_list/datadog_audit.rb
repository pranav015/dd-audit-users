#!/usr/bin/env ruby

require 'csv'
require 'net/http'
require 'json'
require 'fileutils'

require 'faraday'
require 'faraday/net_http'

require 'dotenv'
Dotenv.load('../.env')


def setup_connection
    # Faraday connection details
    Faraday.default_adapter = :net_http

    $dd_region_api = @datadog_region == 'https://api.datadoghq.com' ? ENV['DD_API_KEY'] : ENV['DD_API_KEY_EU']
    $dd_region_app = @datadog_region == 'https://api.datadoghq.com' ? ENV['DD_APP_KEY'] : ENV['DD_APP_KEY_EU']

    $conn = Faraday.new(
    url: @datadog_region,
    params: {param: '1'},
    headers: {
        'Content-Type' => 'application/json',
        'DD-API-KEY' => $dd_region_api ,
        'DD-APPLICATION-KEY' => $dd_region_app
        }
    )
    $conn.request :json
    $conn.response :json
end

def datadog_region_settings
    user_input = ARGV[0].downcase

    if user_input != 'us' && user_input != 'eu'
        abort "Invalid input, exiting..."
        exit 1
    end

    @datadog_region = user_input == 'us' ? 'https://api.datadoghq.com' : 'https://api.datadoghq.eu'
end

def get_user_info
    response = $conn.get(@datadog_region + '/api/v2/users?page[size]=5000' , nil, {  'Content-Type' => 'application/json' })
    @user_response = response.body["data"]
end

def get_role_info
    role_response = $conn.get(@datadog_region + '/api/v2/roles?page[size]=100' , nil, {  'Content-Type' => 'application/json' })

    # Map datadog role ids to role name
    @datadog_roles = Hash.new
    role_response.body["data"].each do |role|
        @datadog_roles[role["id"]] = role["attributes"]["name"]
    end
end

def create_user_list
    # create a 2D array of users to write to csv file
    @user_list = Array.new

    @user_response.each do |user|
        row = Array.new
        role_ids = ''
        role_names = ''

        user["relationships"]["roles"]["data"].each do |user_role|
            role_ids << ", " unless role_ids.empty?
            role_ids << user_role["id"]

            role_names << ", " unless role_names.empty?
            role_names << @datadog_roles[user_role["id"]]
        end

        row << user["attributes"]["name"]
        row << user["attributes"]["email"]
        row << user["attributes"]["status"]
        row << role_ids
        row << role_names
        row << user["attributes"]["created_at"]
        row << user["attributes"]["modified_at"]

        @user_list << row
    end
end

def write_to_csv
    region =  @datadog_region == 'https://api.datadoghq.com' ? 'us' : 'eu'
    headers = ["Name", "Email", "Status", "Role Ids", "Role Names", "Created At", "Modified At"]
    CSV.open("users_#{region}.csv", "w") do |csv|
        csv << headers

        @user_list.each do |user_row|
            csv << user_row
        end
    end

end

# method calls
datadog_region_settings
setup_connection
get_user_info
get_role_info
create_user_list
write_to_csv