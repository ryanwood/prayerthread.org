class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :group_id, :sender_id
      t.string :recipient_email, :token
      t.datetime :sent_at, :accepted_at
      t.integer :accepted_user_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :invitations
  end
end
