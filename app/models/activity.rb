class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :prayer
  
  validates_presence_of :user, :prayer
  
  BUCKETS = [:today, :yesterday, :this_week, :last_week]
  
  named_scope :on_behalf_of, lambda { |user| { :joins => :prayer, :conditions => { :prayers => { :user_id => user } } } }
  named_scope :regarding, lambda { |prayer| { :conditions => { :prayer_id => prayer } } }
  named_scope :actor, lambda { |user| { :conditions => { :user_id => user } } }
  
  named_scope :today,      lambda { { :conditions => [ "activities.created_at >= ? AND activities.created_at < ?", Time.zone.now.midnight.utc, Time.zone.now.midnight.tomorrow.utc ] } }
  named_scope :yesterday,  lambda { { :conditions => [ "activities.created_at >= ? AND activities.created_at < ?", Time.zone.now.midnight.yesterday.utc, Time.zone.now.midnight.utc ] } }
  named_scope :this_week,  lambda { { :conditions => [ "activities.created_at >= ? AND activities.created_at < ?", Time.zone.now.beginning_of_week.utc , Time.zone.now.midnight.yesterday.utc ] } }
  named_scope :last_week,  lambda { { :conditions => [ "activities.created_at >= ? AND activities.created_at < ?", Time.zone.now.beginning_of_week.utc - 7.days, Time.zone.now.beginning_of_week.utc ] } }
  named_scope :this_month, lambda { { :conditions => [ "activities.created_at >= ? AND activities.created_at < ?", Time.zone.now.beginning_of_month.utc, Time.zone.now.beginning_of_week.utc - 7.days ] } }
  named_scope :last_month, lambda { { :conditions => [ "activities.created_at >= ? AND activities.created_at < ?", (Time.zone.now.beginning_of_month.utc - 1.day).beginning_of_month.utc, Time.zone.now.beginning_of_month.utc ] } }
  
  named_scope :rolling_week,  lambda { { :conditions => [ "activities.created_at >= ?", 7.days.ago ] } }
  
  before_create :allowed?
  
  def self.find_all_grouped(user)
    BUCKETS.inject({}) do |hash, key|
      hash[key] = on_behalf_of(user).send(key)
      hash
    end
  end
  
  def self.allowed?(user, prayer)
    !self.actor(user).regarding(prayer).today.exists?
  end
  
  
  protected
  
  def action_text
    ''
  end
  
  def allowed?
    self.class.allowed? user, prayer
  end
end
