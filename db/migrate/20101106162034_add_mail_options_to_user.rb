class AddMailOptionsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :send_reminder, :boolean
    add_column :users, :send_announcements, :boolean

    User.update_all [ "send_reminder = ?, send_announcements = ?", true, true ]
  end

  def self.down
    remove_column :users, :send_announcements
    remove_column :users, :send_reminder
  end
end
