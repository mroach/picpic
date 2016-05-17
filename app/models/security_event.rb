class SecurityEvent < ActiveRecord::Base
  include ClassyEnum::ActiveRecord

  belongs_to :user

  # Define the 'event_type' attribute as an enum
  # See app/enums/security_event_type.rb for the definition
  classy_enum_attr :event_type, class_name: 'SecurityEventType'

  # Init the timestamp column which isn't nullable
  before_create :set_timestamp

  default_scope { order('time DESC') }

  def self.logins
    where(event_type: :login)
  end

  def self.logouts
    where(event_type: :logout)
  end

  def self.latest
    order('time DESC')
  end

  def readonly?
    persisted?
  end

  protected

  def set_timestamp
    self.time = Time.now.utc
  end
end
