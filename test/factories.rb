# Clearance

Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.define :user do |user|
  user.first_name            "John"
  user.last_name             "Doe"
  user.email                 { Factory.next :email }
  user.password              { "password" }
  user.password_confirmation { "password" }
end

Factory.define :email_confirmed_user, :parent => :user do |user|
  user.email_confirmed { true }
end

# Application

Factory.define :prayer do |f|
  f.title "My Request"
  f.body "Lord help me to honor you"
  f.association :user, :factory => :email_confirmed_user
end

Factory.define :comment do |f|
  f.body "Keep praying!"
  f.association :prayer
  f.association :user, :factory => :email_confirmed_user
end

Factory.define :group do |f|
  f.name "My group"
  f.association :owner, :factory => :email_confirmed_user
end

Factory.define :invitation do |f|
  f.recipient_email "dave@nowhere.com"
  f.association :group
  # Use the group owner as the sender
  f.after_build {|i| i.sender = i.group.owner }
end

Factory.define :membership do |f|
  f.association :group
  f.association :user, :factory => :email_confirmed_user
  f.notification_level 1
end

Factory.define :intercession do |f|
  f.association :prayer
  f.association :user, :factory => :email_confirmed_user
end

