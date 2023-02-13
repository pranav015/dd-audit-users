#!/usr/bin/env ruby

require 'csv'
require 'net/http'
require 'json'
require 'fileutils'

require 'faraday'
require 'faraday/net_http'

require '../setup'
require '../config/urls'

def get_user_info(user_status_url)
  response = $conn.get($datadog_region + user_status_url, nil, { 'Content-Type' => 'application/json' })
  @user_response = response.body['data']
end

def get_role_info
  role_response = $conn.get($datadog_region + dd_roles_base_url, nil, { 'Content-Type' => 'application/json' })

  # Map datadog role ids to role name
  @datadog_roles = {}
  role_response.body['data'].each do |role|
    @datadog_roles[role['id']] = role['attributes']['name']
  end
end

# create a 2D array of users to write to csv file
def create_user_list
  @user_list = []

  @user_response.each do |user|
    row = []
    role_ids = ''
    role_names = ''

    user['relationships']['roles']['data'].each do |user_role|
      role_ids << ', ' unless role_ids.empty?
      role_ids << user_role['id']

      role_names << ', ' unless role_names.empty?
      role_names << @datadog_roles[user_role['id']]
    end

    row << user['attributes']['name']
    row << user['attributes']['email']
    row << user['attributes']['status']
    row << role_ids
    row << role_names
    row << user['attributes']['created_at']
    row << user['attributes']['modified_at']

    @user_list << row
  end
end

def write_to_csv(file_name)
  region =  $datadog_region == dd_us_base_url ? 'us' : 'eu'
  headers = ['Name', 'Email', 'Status', 'Role Ids', 'Role Names', 'Created At', 'Modified At']

  # Create output directory if it doesn't exist
  FileUtils.mkdir('./output') unless Dir.exist?('./output')

  CSV.open("./output/#{file_name}_#{region}.csv", 'w') do |csv|
    csv << headers

    @user_list.each do |user_row|
      csv << user_row
    end
  end
end

def generate_audit_report(dd_url, file_name)
  puts "Generating report for #{file_name}-users..."

  # method calls (in sequential order)
  datadog_region_settings
  setup_connection
  get_user_info(dd_url)
  get_role_info
  create_user_list
  write_to_csv(file_name)
end

def start_message
  puts 'Application running...'
end

def end_message
  puts 'Completed!'
end

def run_application
  start_message
  generate_audit_report(dd_all_users_url, 'all')               # Generate report for all users
  generate_audit_report(dd_all_active_users_url, 'active')     # Generate report for all active users
  generate_audit_report(dd_all_disabled_users_url, 'disabled') # Generate report for all disabled users
  generate_audit_report(dd_all_pending_users_url, 'pending')   # Generate report for all pending users
  end_message
end

run_application
