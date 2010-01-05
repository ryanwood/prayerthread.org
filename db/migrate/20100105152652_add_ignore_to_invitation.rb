class AddIgnoreToInvitation < ActiveRecord::Migration
  def self.up
    add_column :invitations, :ignored, :boolean, :default => false
  end

  def self.down
    remove_column :invitations, :ignored
  end
end
