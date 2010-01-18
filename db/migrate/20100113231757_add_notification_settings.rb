class AddNotificationSettings < ActiveRecord::Migration
  def self.up
    add_column :memberships, :notification_level, :integer
  end

  def self.down
    remove_column :memberships, :notification_level
  end
end
