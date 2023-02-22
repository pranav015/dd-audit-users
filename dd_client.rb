#!/usr/bin/env ruby
# frozen_string_literal: true

require '../config/setup'

class DDClient
    attr_reader :DD_REGION
    
    def initialize
        @DD_REGION = datadog_region_settings.freeze
        @DD_CONNECTION = setup_connection(@DD_REGION).freeze
    end

    def get_data(dd_url)
        response = @DD_CONNECTION.get(@DD_REGION + dd_url, nil, { 'Content-Type' => 'application/json' })

        response
    end
end
