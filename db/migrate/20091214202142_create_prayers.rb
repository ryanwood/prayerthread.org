class CreatePrayers < ActiveRecord::Migration
  def self.up
    create_table :prayers do |t|
      t.string :title
      t.text :body
      t.integer :user_id
      t.boolean :private, :default => false
      t.timestamps
    end
  end
  
  def self.down
    drop_table :prayers
  end
end
