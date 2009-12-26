class AddThreadUpdatedAtToPrayers < ActiveRecord::Migration
  def self.up
    add_column :prayers, :thread_updated_at, :datetime
  end

  def self.down
    remove_column :prayers, :thread_updated_at
  end
end
