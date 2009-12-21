class ChangeAcceptedByToRecipientId < ActiveRecord::Migration
  def self.up
    change_table :invitations do |t|
      t.rename :accepted_user_id, :recipient_id
    end
  end

  def self.down
    change_table :invitations do |t|
      t.rename :recipient_id, :accepted_user_id
    end
  end
end
