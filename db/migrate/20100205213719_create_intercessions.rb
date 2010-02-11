class CreateIntercessions < ActiveRecord::Migration
  def self.up
    create_table :intercessions do |t|
      t.integer :user_id, :prayer_id
      t.string :info
      t.timestamps
    end
  end

  def self.down
    drop_table :intercessions
  end
end
