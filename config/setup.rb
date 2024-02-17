#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './sites'
require 'dotenv'
Dotenv.load('../.env')

def initialize_client
  # retrieve region details
  region = get_region_settings

  DatadogAPIClient.configure do |config|
    if region.eql?('us')
      config.api_key = ENV['DD_API_KEY']
      config.application_key = ENV['DD_APP_KEY']
    elsif region.eql?('eu')
      config.api_key = ENV['DD_API_KEY_EU']
      config.application_key = ENV['DD_APP_KEY_EU']
    end

    config.server_variables[:site] = region.eql?('us') ? dd_us_site : dd_eu_site
    config.enable_retry = true
  end
end

def get_region_settings
  Kernel.abort('Region parameter must be set') if ARGV.empty?
  Kernel.abort('Wrong number of parameters') if ARGV.length > 1

  user_input = ARGV[0].downcase

  if user_input != 'us' && user_input != 'eu'
    abort 'Invalid input, exiting...'
    exit 1
  end

  user_input
end
