def datadog_region_settings
    user_input = ARGV[0].downcase

    if user_input != 'us' && user_input != 'eu'
        abort "Invalid input, exiting..."
        exit 1
    end

    @datadog_region = user_input == 'us' ? 'https://api.datadoghq.com' : 'https://api.datadoghq.eu'
end

def setup_connection
    # Faraday connection details
    Faraday.default_adapter = :net_http

    dd_region_api = @datadog_region == 'https://api.datadoghq.com' ? ENV['DD_API_KEY'] : ENV['DD_API_KEY_EU']
    dd_region_app = @datadog_region == 'https://api.datadoghq.com' ? ENV['DD_APP_KEY'] : ENV['DD_APP_KEY_EU']

    $conn = Faraday.new(
    url: @datadog_region,
    params: {param: '1'},
    headers: {
        'Content-Type' => 'application/json',
        'DD-API-KEY' => dd_region_api ,
        'DD-APPLICATION-KEY' => dd_region_app
        }
    )
    $conn.request :json
    $conn.response :json
end
