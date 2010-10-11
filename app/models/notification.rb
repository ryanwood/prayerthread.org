class NotificationLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    "#{timestamp.to_formatted_s(:db)} #{severity} #{msg}\n" 
  end 
end

class Notification
  
  def self.fire(event, model)
    Delayed::Job.enqueue new(event, model)
  end
  
  def initialize(event_type, model)
    @event = Event.new(event_type, model)
  end
  
  def perform
    @event.audience.each do |recipient|
      NotificationMailer.send(@event.mailer, recipient, @model).deliver
    end
  end
    
  private
  
    def logger
      @logger ||= create_logger
    end
  
    def create_logger
      logger = NotificationLogger.new(File.open( Rails.root.join('log', 'notification.log'), 'a'))
      logger.level = Rails.logger.level
      logger
    end 
end
