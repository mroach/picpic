Warden::Manager.after_authentication do |user, auth, opts|
  Rails.logger.debug "Authenticated #{user.inspect}"
  SecurityEvent.create(
    user: user,
    event_type: SecurityEventType::Login,
    ip_address: auth.request.remote_ip,
    client_application: auth.request.user_agent
  )
end

Warden::Manager.before_logout do |user, auth, opts|
  Rails.logger.debug "Logging-out #{user.inspect}"
  SecurityEvent.create(
    user: user,
    event_type: SecurityEventType::Logout,
    ip_address: auth.request.remote_ip,
    client_application: auth.request.user_agent
  )
end
