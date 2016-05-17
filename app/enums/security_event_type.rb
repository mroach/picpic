class SecurityEventType < ClassyEnum::Base
end

class SecurityEventType::Login < SecurityEventType
end

class SecurityEventType::Logout < SecurityEventType
end

class SecurityEventType::LoginBlocked < SecurityEventType
end
