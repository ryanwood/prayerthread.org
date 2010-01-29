class AddIndividualNotificationsToMembership < ActiveRecord::Migration
  def self.up
    change_table :memberships do |t|
      t.boolean :notify_on_prayer_created,
        :notify_on_prayer_answered,
        :notify_on_comment_from_originator,
        :notify_on_comment_to_originator, :null => false, :default => 0
    end
    Membership.update_all "notify_on_prayer_created = 1, notify_on_prayer_answered = 1, notify_on_comment_from_originator = 1", "notification_level > 0"
    Membership.update_all "notify_on_comment_to_originator = 1", "notification_level = 2"
  end

  def self.down
    change_table :memberships do |t|
      t.remove :notify_on_prayer_created,
        :notify_on_prayer_answered,
        :notify_on_comment_from_originator,
        :notify_on_comment_to_originator
    end
  end
end
