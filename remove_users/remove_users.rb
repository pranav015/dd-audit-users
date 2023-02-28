#!/usr/bin/env ruby

require 'csv'
require 'net/http'
require 'json'
require 'fileutils'

require 'faraday'
require 'faraday/net_http'

require '../config'

@user_map = {}
@users_not_found = []

def get_user_info
  begin
    response = @client.get_data(dd_all_active_users_url)
    @user_response = response.body['data']
  end
  rescue IOError => e
    Kernel.abort("Error reaching endpoint: #{dd_all_active_users_url}")
  end
end

def create_user_map
  @user_response.each do |user|
    @user_map[user['attributes']['email']] = user['id']
  end
end

def remove_users
  puts 'Removing users...this may take a few minutes'
  region = @client.DD_REGION == dd_us_base_url ? 'us' : 'eu'
  dd_url = @client.DD_REGION == dd_us_base_url ? dd_us_base_url : dd_eu_base_url
  file_path = "users-to-remove-#{region}.csv"

  # Create csv files if they don't exist
  if !File.exists?(file_path)
    file = File.open('./output/filters.tf', 'w')
    file.close

    Kernel.abort("CSV files are empty")
  end

  # read in user emails from csv file and disable their accounts
  CSV.foreach(file_path, headers: false, col_sep: ',') do |item|
    email = item[0]
    user_id = @user_map[email]

    if user_id.nil?
      @users_not_found << email
    else
      begin
        @client.remove_data(dd_url + dd_single_user_id_url + user_id)
      end
      rescue IOError => e
        Kernel.abort("Error reaching endpoint: #{dd_url + dd_single_user_id_url}")
      end

      puts "user disabled: #{email}"

      # avoid rate limits
      sleep(3)
    end
  end
end

def list_users_not_found
  region = @client.DD_REGION == dd_us_base_url ? 'us' : 'eu'
  begin
    file = File.open("missing_users-#{region}.csv", 'a')
    file.write("List of missing users:\n")
    @users_not_found.each do |user|
      file.write(user)
      file.write("\n")
    end
  rescue IOError => e
  # some error occur, dir not writable etc.
  ensure
    file&.close
  end
end

def start_message
  puts 'Application running...'
end

def end_message
  puts 'Completed!'
end

def run_application
  @client = DDClient.new

  # method calls (in sequential order)
  start_message
  get_user_info
  create_user_map
  remove_users
  list_users_not_found
  end_message
end

run_application
