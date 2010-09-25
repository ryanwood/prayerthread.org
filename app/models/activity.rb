class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :prayer
  
  validates_presence_of :user, :prayer
  
  BUCKETS = [:today, :yesterday, :this_week, :last_week, :older_than_last_week]
  
  scope :on_behalf_of, lambda { |user| joins(:prayer).where(:prayers => { :user_id => user }) }
  scope :regarding, lambda { |prayer| where(:prayers => { :id => prayer}) }
  scope :actor, lambda { |user| where(:users => {:id => user }) }
  
  scope :today,      lambda { includes(:prayer, :user).where("activities.created_at >= ? AND activities.created_at < ?", Time.zone.now.midnight.utc, Time.zone.now.midnight.tomorrow.utc) }
  scope :yesterday,  lambda { includes(:prayer, :user).where("activities.created_at >= ? AND activities.created_at < ?", Time.zone.now.midnight.yesterday.utc, Time.zone.now.midnight.utc) }
  scope :this_week,  lambda { includes(:prayer, :user).where("activities.created_at >= ? AND activities.created_at < ?", Time.zone.now.beginning_of_week.utc , Time.zone.now.midnight.yesterday.utc) }
  scope :last_week,  lambda { includes(:prayer, :user).where("activities.created_at >= ? AND activities.created_at < ?", Time.zone.now.beginning_of_week.utc - 7.days, Time.zone.now.beginning_of_week.utc) }
  scope :this_month, lambda { includes(:prayer, :user).where("activities.created_at >= ? AND activities.created_at < ?", Time.zone.now.beginning_of_month.utc, Time.zone.now.beginning_of_week.utc - 7.days) }
  scope :last_month, lambda { includes(:prayer, :user).where("activities.created_at >= ? AND activities.created_at < ?", (Time.zone.now.beginning_of_month.utc - 1.day).beginning_of_month.utc, Time.zone.now.beginning_of_month.utc) }
  scope :older_than_last_week, lambda { includes(:prayer, :user).where("activities.created_at < ?", Time.zone.now.beginning_of_week.utc - 7.days).limit(30) }
  
  scope :rolling_week,  lambda { includes(:prayer, :user).where("activities.created_at >= ?", 7.days.ago) }
  
  before_create :allowed?
  
  def self.find_all_grouped(user)
    BUCKETS.inject({}) do |hash, key|
      hash[key] = on_behalf_of(user).send(key)
      hash
    end
  end
  
  def self.allowed?(user, prayer)
    true
  end
  
  
  protected
  
  def action_text
    ''
  end
  
  def allowed?
    self.class.allowed? user, prayer
  end
end
