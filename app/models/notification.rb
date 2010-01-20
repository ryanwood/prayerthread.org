class Notification
  include ActiveSupport::Inflector
  
  EVENTS = [:created, :updated]
  
  def self.process(event, model)
    new(event, model).process
  end
  
  def initialize(event, model)
    raise(ArgumentError, "Invalid event for notification: #{event}.") unless EVENTS.include?(event)
    @event = event
    @model = model
  end
  
  def process
    send( "#{underscore(@model.class)}_#{@event}".to_sym )
  end
    
  protected
  
    def prayer_created
      if @model.kind_of? Prayer
        prayer = @model
        level = 1
        recipients_for(prayer, level, prayer.user).each do |recipient|
          NotificationMailer.send_later(:deliver_prayer_created, recipient, prayer)
        end
      end
    end

    def comment_created
      if @model.kind_of? Comment
        comment = @model
        level = comment.user == comment.prayer.user ? 1 : 2
        recipients_for(comment.prayer, level, comment.user).each do |recipient|
          NotificationMailer.send_later(:deliver_comment_created, recipient, comment)
        end
      end
    end
    
    def logger
      @logger ||= RAILS_DEFAULT_LOGGER
    end
  
    def recipients_for(prayer, level, *filtered_users)
      memberships = prayer.groups.map { |g| g.memberships.select {|m| m.notification_level >= level} }.flatten
      memberships.map { |m| m.user }.uniq - filtered_users
    end

end