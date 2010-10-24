Clearance.configure do |config|
  config.mailer_sender = Settings.mail.from
  # config.cookie_expiration = lambda { 2.weeks.from_now.utc }
end

