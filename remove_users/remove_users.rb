#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'datadog_remove_users_client'

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
