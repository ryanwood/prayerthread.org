class AddAnswerToPrayer < ActiveRecord::Migration
  def self.up
    add_column :prayers, :answered_at, :datetime
    add_column :prayers, :answer, :text
    Prayer.update_all "answered_at = updated_at", "answered = 1"
    remove_column :prayers, :answered
  end

  def self.down
    add_column :prayers, :answered, :boolean
    Prayer.update_all "answered = 1", "answered_at IS NOT NULL"
    remove_column :prayers, :answered_at
    remove_column :prayers, :answer
  end
end
