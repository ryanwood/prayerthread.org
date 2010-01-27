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
        recipients_for(prayer, [1,2], prayer.user).each do |recipient|
          NotificationMailer.send_later(:deliver_prayer_created, recipient, prayer)
        end
      end
    end

    def comment_created
      if @model.kind_of? Comment
        comment = @model
        if comment.user == comment.prayer.user
          recipients_for(comment.prayer, [1,2], comment.user).each do |recipient|
            NotificationMailer.send_later(:deliver_comment_created, recipient, comment)
          end
        else
          # Only notify the prayer user
          recipients_for(comment.prayer, 2, comment.user).each do |recipient|
            if recipient == comment.prayer.user
              NotificationMailer.send_later(:deliver_comment_created, recipient, comment)
              break
            end
          end
        end
      end
    end
    
    def logger
      @logger ||= RAILS_DEFAULT_LOGGER
    end
  
    def recipients_for(prayer, levels, *filtered_users)
      levels = [levels] unless levels.is_a?(Array)
      memberships = prayer.groups.map { |g| g.memberships.select {|m| levels.include?(m.notification_level)} }.flatten
      memberships.map { |m| m.user }.uniq - filtered_users
    end

end