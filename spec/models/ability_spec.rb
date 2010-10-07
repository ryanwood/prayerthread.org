require 'spec_helper'
require "cancan/matchers"

describe "Ability: A user" do
  let(:user){ User.make(:confirmed) }
  let(:ability) { Ability.new(user) }

  context "(prayers)" do
    it "can only delete prayers they own" do
      ability.should be_able_to(:destroy, Prayer.make(:user => user))
      ability.should_not be_able_to(:destroy, Prayer.make)
    end

    it "can only edit prayers they owns" do
      ability.should be_able_to(:update, Prayer.make(:user => user))
      ability.should_not be_able_to(:update, Prayer.make)
    end
  end

  context "(groups)" do
    it "can create a group" do
      ability.should be_able_to(:create, Group)
    end

    it "can modify groups they own" do
      ability.should be_able_to(:modify, Group.make(:owner => user))
      ability.should_not be_able_to(:modify, Group.make)
    end
  end

  context "(invitations)" do
    it "can delete invitations from a group they own" do
      group = Group.make(:owner => user)
      ability.should be_able_to(:destroy, Invitation.make(:group => group))
      ability.should_not be_able_to(:destroy, Invitation.make)
    end
    
    it "can delete received invitations" do
      group = Group.make(:owner => User.make(:confirmed))
      invitation = Invitation.make(:group => group, :recipient => user)
      invitation.recipient.should == user
      ability.should be_able_to(:destroy, invitation)
      ability.should_not be_able_to(:destroy, Invitation.make)
    end
  end

  context "(memberships)" do
    it "can delete their own memberships" do 
      membership = Membership.make(:group => Group.make, :user => user)
      ability.should be_able_to(:destroy, membership)
      ability.should_not be_able_to(:destroy, Membership.make)
    end

    context "as a group owner" do
      let(:group) { Group.make(:owner => user) }

      it "cannot delete their membership" do
        ability.should_not be_able_to(:destroy, Membership.make(:group => group, :user => user))
      end

      it "can delete other's memberships in the group" do
        ability.should be_able_to(:destroy, Membership.make(:group => group))
     end
    end

  end
end
