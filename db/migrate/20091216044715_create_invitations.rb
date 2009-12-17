class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :group_id, :sender_id
      t.string :recipient_email, :token
      t.datetime :sent_at, :accepted_at
      t.timestamps
    end    
    add_column :users, :invitation_id, :integer
  end
  
  def self.down
    remove_column :users, :invitation_id
    drop_table :invitations
  end
end
