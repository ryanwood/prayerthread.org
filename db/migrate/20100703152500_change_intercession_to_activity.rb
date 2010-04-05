class ChangeIntercessionToActivity < ActiveRecord::Migration
  def self.up
    rename_table :intercessions, :activities
    add_column :activities, :type, :string
    rename_column :activities, :info, :comment
    
    execute "UPDATE activities SET type = 'Intercession' WHERE type IS NULL"
  end

  def self.down
    rename_column :activities, :comment, :info
    remove_column :activities, :type
    rename_table :activities
  end
end
