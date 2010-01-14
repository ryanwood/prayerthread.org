class AddNotificationSettings < ActiveRecord::Migration
  def self.up
    add_column :memberships, :notify_on_create, :boolean, :default => true
    add_column :memberships, :notify_on_update, :boolean, :default => true
  end

  def self.down
    remove_column :memberships, :notify_on_update
    remove_column :memberships, :notify_on_create
  end
end
