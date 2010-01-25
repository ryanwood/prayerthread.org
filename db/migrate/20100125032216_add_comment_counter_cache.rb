class AddCommentCounterCache < ActiveRecord::Migration
  def self.up
    add_column :prayers, :comments_count, :integer, :default => 0
    
    Prayer.reset_column_information
    Prayer.find(:all).each do |p|
      Prayer.update_counters p.id, :comments_count => p.comments.length
    end
  end

  def self.down
    remove_column :prayers, :comments_count
  end
end
