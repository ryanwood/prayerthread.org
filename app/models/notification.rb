class NotificationLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    "#{timestamp.to_formatted_s(:db)} #{severity} #{msg}\n" 
  end 
end

class Event < Struct.new(:prayer, :condition, :mailer, :filtered_users)
end

class Notification
  
  EVENTS = [:created, :answered]

  def self.fire(event, model)
    Delayed::Job.enqueue new(event, model)
  end
  
  def initialize(event, model)
    raise(ArgumentError, "Invalid event for notification: #{event}.") unless EVENTS.include?(event)
    @event_name = event
    @model = model
  end
  
  def perform
    event = Event.new
    if @model.kind_of? Prayer
      prayer = @model
      event.prayer = prayer
      event.filtered_users = [prayer.user]
      event.condition = "prayer_#{@event_name}"
      event.mailer = "deliver_#{event.condition}".to_sym
    elsif @model.kind_of?(Comment) && @event_name == :created
      comment = @model
      event.prayer = @model.prayer
      event.filtered_users = [@model.user]
      if comment.user == comment.prayer.user
        event.condition = "comment_from_originator"
      else
        event.condition = "comment_to_originator"
      end
      event.mailer = :deliver_comment_created
    else
      raise ArgumentError, "There is no '#{@event_name}' notification configured for the #{@model.class} class."
    end
    
    audience = build_audience(event)
    notify(audience, event.mailer)
  end
    
  private
    
    def notify(audience, mailer)
      audience.each do |recipient|
        NotificationMailer.send(mailer, recipient, @model)
      end
    end
    
    def build_audience(event)
      field = "notify_on_#{event.condition}"
      memberships = case event.condition
        when "comment_to_originator"
          Membership.find :all, :conditions => ["group_id IN (?) AND #{field} = ? AND user_id = ?", event.prayer.groups, true, event.prayer.user]
        else
          Membership.find :all, :conditions => ["group_id IN (?) AND #{field} = ?", event.prayer.groups, true]
      end
      memberships.map { |m| m.user }.uniq - event.filtered_users
    end
  
    def logger
      @logger ||= create_logger
    end
  
    def create_logger
      logger = NotificationLogger.new(File.open("#{RAILS_ROOT}/log/notification.log", 'a'))
      logger.level = RAILS_DEFAULT_LOGGER.level
      logger
    end 
end