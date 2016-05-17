class CreateSecurityEvents < ActiveRecord::Migration
  def change
    create_table :security_events do |t|
      t.references  :user, index: true
      t.string      :event_type
      t.string      :comments
      t.datetime    :time, null: false
      t.string      :ip_address
      t.string      :server_application
      t.string      :client_application

      t.timestamps null: false
    end
    add_foreign_key :security_events, :user
    add_index :security_events, :time
  end
end
