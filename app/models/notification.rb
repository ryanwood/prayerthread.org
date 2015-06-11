class Notification < ActiveRecord::Base
  belongs_to :source, polymorphic: true

  validates_presence_of :source, :event_type

  def self.fire(event, source)
    create(event_type: event, source: source)
  end

  def self.not_sent
    where(sent: false)
  end

  def event
    @event ||= Event.new(event_type.to_sym, source)
  end

  def send!
    event.audience.each do |recipient|
      NotificationMailer.send(event.mailer, recipient, event.source).deliver
    end

    update_attributes(sent: true)
  end
end
