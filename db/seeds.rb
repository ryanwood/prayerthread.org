# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# INSERT INTO `users` (`id`,`first_name`,`last_name`,`email`,`encrypted_password`,`salt`,`confirmation_token`,`remember_token`,`email_confirmed`,`created_at`,`updated_at`,`invitation_id`)
# VALUES
#   (1, 'Ryan', 'Wood', 'ryan.wood@gmail.com', '472e56ed841202842dabd039aaa22306ff862e37', '361d17c0b73aba045dbb65ffc8fbf12da18b9c2e', NULL, '9336827466ff91e8c6feb712ab33824a97700bd7', 1, '2009-12-16 20:51:44', '2009-12-18 05:38:21', NULL);

passwords = {:password => 'password', :password_confirmation => 'password'}

puts "Adding default users..."
users = User.create!([
  passwords.merge( { :first_name => 'Ryan', :last_name => 'Wood', :email => 'ryan.wood@gmail.com' } ),
  passwords.merge( { :first_name => 'Joe', :last_name => 'Wike', :email => 'joe@amyadele.com' } )
])
users.each {|u| u.update_attribute :email_confirmed, true }

puts "Adding default groups..."

Group.create!([
  { :name => 'JCA', :owner_id => 1 }
])