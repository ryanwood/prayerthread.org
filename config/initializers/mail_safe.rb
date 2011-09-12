if defined?(MailSafe::Config)
  MailSafe::Config.internal_address_definition = /.*@prayerthread\.org/i
  MailSafe::Config.replacement_address = 'ryan@prayerthread.org'
end
