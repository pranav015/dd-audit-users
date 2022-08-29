# This file contains all relevant urls for scripts 

def dd_us_base_url
    'https://api.datadoghq.com'
end

def dd_eu_base_url
    'https://api.datadoghq.eu'
end

def dd_remove_users_url
    '/api/v2/users/'
end

def dd_all_users_url
    '/api/v2/users?page[size]=6000'
end

def dd_all_active_users_url
    '/api/v2/users?page[size]=6000&filter[status]=Active'
end

def dd_all_disabled_users_url
    '/api/v2/users?page[size]=6000&filter[status]=Disabled'
end

def dd_all_pending_users_url
    '/api/v2/users?page[size]=6000&filter[status]=Pending'
end

def dd_roles_base_url
    '/api/v2/roles?page[size]=100'
end
