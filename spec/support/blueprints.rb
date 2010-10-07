require 'machinist/active_record'

# Clearance

User.blueprint do
  first_name            { Faker::Name.first_name }
  last_name             { Faker::Name.last_name }
  email                 { "user#{sn}@example.com" }
  password              { "password" }
  password_confirmation { "password" }
end

User.blueprint(:confirmed) do
  email_confirmed { true }
end

# Application

Prayer.blueprint do
  title { "My Request" }
  body  { "Lord help me to honor you" }
  user  { User.make(:confirmed) }
end

Comment.blueprint do
  body { "Keep praying!" }
  prayer
  user   { User.make(:confirmed) }
end

Group.blueprint do
  name { "My group" }
  owner  { User.make(:confirmed) }
end

Invitation.blueprint do
  recipient_email { "dave@nowhere.com" }
  group
  sender { object.group.owner }
end

Membership.blueprint do
  group
  user   { User.make(:confirmed) }
  notification_level { 1 }
end

Intercession.blueprint do
  prayer
  user { User.make(:confirmed) }
end

Nudge.blueprint do
  prayer
  user { User.make(:confirmed) }
end