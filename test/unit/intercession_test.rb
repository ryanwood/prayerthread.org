require 'test_helper'

class IntercessionTest < ActiveSupport::TestCase
  should_belong_to :user, :prayer
  should_validate_presence_of :user, :prayer
  
  should "only allow one intercession per prayer per user per day" do
    user = Factory(:email_confirmed_user)
    prayer = Factory(:prayer)
    first = Factory.build(:intercession, :user => user, :prayer => prayer) 
    second = Factory.build(:intercession, :user => user, :prayer => prayer)
    assert( first.save )
    assert( !second.save )
  end
end
