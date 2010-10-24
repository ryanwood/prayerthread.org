require 'spec_helper'
require "cancan/matchers"

describe Ability do
  let(:user){ User.make(:confirmed) }
  let(:ability) { Ability.new(user) }
  
  let(:group) { Group.make! }
  let(:prayer) do
    p = Prayer.make!
    group.prayers << p
    p
  end

  context "Prayers" do
    it "can only delete prayers they own" do
      ability.should be_able_to(:destroy, Prayer.make(:user => user))
      ability.should_not be_able_to(:destroy, Prayer.make)
    end

    it "can only edit prayers they own" do
      ability.should be_able_to(:update, Prayer.make(:user => user))
      ability.should_not be_able_to(:update, Prayer.make)
    end
    
    context ":read" do
      it "can read prayers for groups they belong" do
        Membership.make!(:user => user, :group => group)
        ability.should be_able_to(:read, prayer)
      end

      it "cannot read prayers for groups they do not belong" do
        ability.should_not be_able_to(:read, prayer)
      end
    end
  end

  context "Groups" do
    context ":read" do
      it "can view a group as a member" do
        Membership.make!(:user => user, :group => group)
        ability.should be_able_to(:read, group)
      end
    
      it "cannot view a group as a non-member" do
        ability.should_not be_able_to(:modify, Group.make)
      end
    end

    it "can create a group" do
      ability.should be_able_to(:create, Group)
    end

    it "can modify groups as an owner" do
      ability.should be_able_to(:modify, Group.make(:owner => user))
      ability.should_not be_able_to(:modify, Group.make)
    end
    
    it "can destroy groups as an owner" do
      ability.should be_able_to(:destroy, Group.make(:owner => user))
      ability.should_not be_able_to(:destroy, Group.make)
    end
  end
  
  context "Comments" do
    let(:comment) { prayer.comments.build }
    
    context ":create" do
      it "can create comments for prayers in groups they belong" do
        Membership.make!(:user => user, :group => group)
        ability.should be_able_to(:create, comment)
      end

      it "cannot create comments for prayers in groups they do not belong" do
        ability.should_not be_able_to(:create, comment)
      end
    end
  end

  context "Invitations" do
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

  context "Memberships" do
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
