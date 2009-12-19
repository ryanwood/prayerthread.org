class CreateGroupsPrayersJoin < ActiveRecord::Migration
  def self.up
    create_table :groups_prayers, :id => false, :force => true do |t|
      t.integer :group_id, :prayer_id
    end
    add_index :groups_prayers, [:group_id, :prayer_id], :unique => true
  end

  def self.down
    drop_table :groups_prayers, :id => false
  end
end
