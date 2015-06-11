class CreateNotifications < ActiveRecord::Migration
  def up
    create_table :notifications do |t|
      t.belongs_to :source, polymorphic: true
      t.string     :event_type
      t.boolean    :sent, default: false, null: false
    end
  end

  def down
    drop_table :notifications
  end
end
