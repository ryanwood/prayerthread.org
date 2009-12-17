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
  f.association :user
end

Factory.define :group do |f|
  f.name "My group"
  f.association :owner, :factory => :user
end

Factory.define :invitation do |f|
  f.recipient_email "dave@nowhere.com"
  f.association :group
  # Use the group owner as the sender
  f.after_build {|i| i.sender = i.group.owner }
end

