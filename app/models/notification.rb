class NotificationLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    "#{timestamp.to_formatted_s(:db)} #{severity} #{msg}\n" 
  end 
end

class Notification
  
  def self.fire(event, source)
    Delayed::Job.enqueue new(event, source)
  end
  
  def initialize(event, source)
    @event = Event.new(event, source)
  end
  
  def perform
    @event.audience.each do |recipient|
      NotificationMailer.send(@event.mailer, recipient, @event.source).deliver
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
