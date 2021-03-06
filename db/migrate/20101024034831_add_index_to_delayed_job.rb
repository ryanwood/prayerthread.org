class AddIndexToDelayedJob < ActiveRecord::Migration
  def self.up
    add_index :delayed_jobs, [:priority, :run_at], :name => 'delayed_jobs_priority'
  end

  def self.down
    remove_index :delayed_jobs, [:priority, :run_at]
  end
end
