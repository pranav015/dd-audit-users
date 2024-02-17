#!/usr/bin/env ruby
# frozen_string_literal: true

require 'csv'
require '../config/setup'
require 'datadog_api_client'

class DatadogUsersListClient
  attr_accessor :user_roles

  def initialize
    # initialize dd client
    initialize_client

    # create empty hash for user roles
    @user_roles = {}

    # get list of user roles and populate hash
    get_user_roles
  end

  def get_user_info(status)
    api_instance = DatadogAPIClient::V2::UsersAPI.new
    opts = {
      page_size: 100,
      filter_status: status
    }

    region = ARGV[0].downcase

    puts "Generating list for all #{status} users in DD #{region}"

    CSV.open("./output/#{status}_#{region}.csv", 'w') do |csv|
      headers = ['Name', 'Email', 'Status', 'Role Ids', 'Role Names', 'Created At', 'Modified At']
      csv << headers

      row = [] # write data here
      role_ids = ''
      role_names = ''

      # call api endpoint and write to csv file
      api_instance.list_users_with_pagination(opts) do |item|
        row << item.attributes.name
        row << item.attributes.email
        row << item.attributes.status

        # loop through roles
        item.relationships.roles.data.each do |role| # pick up here
          role_ids += role_ids.empty? ? role.id.to_s : ", #{role.id}"
          role_names += role_names.empty? ? @user_roles[role.id.to_s].to_s : ", #{@user_roles[role.id.to_s]}"
        end

        # append roles to file
        row << role_ids
        row << role_names

        row << item.attributes.created_at
        row << item.attributes.modified_at

        # append to csv file
        csv << row

        # reset variables
        row = []
        role_ids = ''
        role_names = ''
      end
    end
  end

  private

  def get_user_roles
    roles_api_instance = DatadogAPIClient::V2::RolesAPI.new
    opts = {
      page_size: 100
    }

    response = roles_api_instance.list_roles(opts)

    # loop through roles and add them to hash
    response.data.each do |role|
      @user_roles[role.id] = role.attributes.name
    end
  end
end

# helper methods
def start_message
  puts 'Application running...'
end

def end_message
  puts 'Completed!'
end

# main method
def run_application
  start_message

  dd_client = DatadogUsersListClient.new

  dd_client.get_user_info('Active')
  dd_client.get_user_info('Disabled')
  dd_client.get_user_info('Pending')

  end_message
end

run_application
