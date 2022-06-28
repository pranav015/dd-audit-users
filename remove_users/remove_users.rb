#!/usr/bin/env ruby

require 'csv'
require 'net/http'
require 'json'
require 'fileutils'

require 'faraday'
require 'faraday/net_http'

require '../setup'

DD_All_ACTIVE_USERS_URL = '/api/v2/users?page[size]=5000&filter[status]=Active'.freeze
DD_SINGLE_USER_BASE_URL = '/api/v2/users/'.freeze

@user_map = Hash.new
@users_not_found = Array.new

def get_user_info
    response = $conn.get($datadog_region + DD_All_ACTIVE_USERS_URL, nil, {  'Content-Type' => 'application/json' })
    @user_response = response.body["data"]
end

def create_user_map
    @user_response.each do |user|
        @user_map[user["attributes"]["email"]] = user["id"]
    end
end

def remove_users
    puts "Removing users...this may take a few minutes"
    region = $datadog_region == 'https://api.datadoghq.com' ? 'us' : 'eu'

    # read in user emails from csv file and disable their accounts
    CSV.foreach(("users-to-remove-#{region}.csv"), headers: false, col_sep: ",") do |item|
        email = item[0]
        user_id =  @user_map[email]

        if user_id.nil?
            @users_not_found << email
        else
            $conn.delete($datadog_region + DD_SINGLE_USER_BASE_URL + user_id , nil, {  'Content-Type' => 'application/json' })
            puts "user disabled: #{email}"  #remove this
            sleep(3)
        end
    end
end

def list_users_not_found
    region = $datadog_region == 'https://api.datadoghq.com' ? 'us' : 'eu'
    begin
        file = File.open("missing_users-#{region}.csv", "a")
        file.write("List of missing users:\n")
        @users_not_found.each do |user|
            file.write(user)
            file.write("\n")
        end
    rescue IOError => e
        #some error occur, dir not writable etc.
    ensure
        file.close unless file.nil?
    end
end

def start_message
    puts "Application running..."
end

def end_message
    puts "Completed!"
end

def run_application
    # method calls (in sequential order)
    start_message
    datadog_region_settings
    setup_connection
    get_user_info
    create_user_map
    remove_users
    list_users_not_found
    end_message
end

run_application