#!/usr/bin/env ruby
# frozen_string_literal: true

require 'csv'
require '../config/setup'
require 'datadog_api_client'

class DatadogRemoveUsersClient
  attr_accessor :user_map, :users_not_found, :api_instance

  def initialize
    # initialize client
    initialize_client

    # api instance
    @api_instance = DatadogAPIClient::V2::UsersAPI.new

    # create empty objects for user map and users not found
    @user_map = {}
    @users_not_found = []

    # create a map of users
    create_user_map
  end

  def remove_users
    opts = {}

    CSV.foreach("users-to-remove-#{ARGV[0].downcase}.csv", headers: false, col_sep: ',') do |line_item|
        email = line_item[0]
        user_id = $user_map[email]
    
        if user_id.nil?
          @users_not_found << email
        else
          @api_instance.disable_user(user_id)
    
          puts "user disabled: #{email}"
    
          # avoid rate limits
          sleep(3)
        end
      end

      puts "Missing users:\n"
      puts @users_not_found
end

  private

  def create_user_map
    opts = {
      page_size: 100,
      filter_status: 'Active' # retrieve only active users
    }

    @api_instance.list_users_with_pagination(opts) do |item|
        @user_map[item.attributes.email] = item.id unless item.attributes.email.nil?
    end
  end
end

def start_message
  puts 'Application running...'
end

def end_message
  puts 'Completed!'
end

def run_application
  start_message

  dd_client = DatadogRemoveUsersClient.new

  # read in and remove users from csv file
  dd_client.remove_users

  end_message
end

run_application
