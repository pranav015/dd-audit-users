# This file contains all relevant urls for scripts 

def dd_us_base_url
    'https://api.datadoghq.com'
end

def dd_all_active_users_url
    '/api/v2/users?page[size]=5000&filter[status]=Active'
end

def dd_roles_base_url
    '/api/v2/roles?page[size]=100'
end