class AddPraiseToPrayer < ActiveRecord::Migration
  def self.up
    add_column :prayers, :praise, :boolean, :default => false
  end

  def self.down
    remove_column :prayers, :praise
  end
end
