require 'test_helper'

class AbilityTest < ActiveSupport::TestCase

  context "A user" do
    setup do
      @user = Factory(:user)
      @ability = Ability.new(@user)
    end
    
    
    # Prayers

    should "only delete prayers they own" do
      assert @ability.can?(:destroy, Factory.build(:prayer, :user => @user))
      assert @ability.cannot?(:destroy, Factory.build(:prayer))
    end
    
    should "only edit prayers they own" do
      assert @ability.can?(:update, Factory.build(:prayer, :user => @user))
      assert @ability.cannot?(:update, Factory.build(:prayer))
    end
    
    
    # # Comments
    # 
    # should "only create comments for prayers that are in my groups" do
    #   group = Factory(:group)
    #   membership = Factory(:membership, :group => group, :user => @user)
    #   prayer_with_access = Factory(:prayer, :groups => [group])
    #   prayer_without_access = Factory(:prayer)
    #   assert @ability.can?(:create, Factory.build(:prayer, :user => @user))
    #   assert @ability.cannot?(:destroy, Factory.build(:prayer))
    # end
    
    
    # Invitations
    
    should "only delete invitations from a group they own" do
      group = Factory.build(:group, :owner => @user)
      invitation = Factory.build(:invitation, :group => group)
      assert @ability.can?(:destroy, invitation)
      assert @ability.cannot?(:destroy, Factory.build(:invitation))
    end
    
    
    #Memberships
    
    should "delete any membership they own" do
      group = Factory.build(:group)
      membership = Factory.build(:membership, :group => group, :user => @user)
      assert @ability.can?(:destroy, membership)
      assert @ability.cannot?(:destroy, Factory.build(:invitation))
    end
    
    context "that owns a group" do
      setup do
        @group = Factory.build(:group, :owner => @user)
      end

      should "not be able to delete their membership" do
        membership = Factory.build(:membership, :group => @group, :user => @user)
        assert @ability.cannot?(:destroy, membership)
      end

      should "be able to delete any memberships other than their's" do
        membership = Factory.build(:membership, :group => @group, :user => Factory(:user))
        assert @ability.can?(:destroy, membership)
      end
    end
    
    

  end

end
