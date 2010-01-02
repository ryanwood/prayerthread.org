class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    
    can :manage, Prayer do |action, prayer|
      prayer && prayer.user == @user
    end

    can [:read, :create], Comment
    # can :create, Comment do |comment|
    #   allowed_groups = comment.prayer.groups
    #   @user.groups.each { |g| return true if allowed_groups.include?(g) }
    #   false
    # end
    can [:update, :destroy], Comment do |comment|
      comment && comment.user == @user
    end
    
    can :destroy, Invitation do |invitation|
      invitation && invitation.group.owner == @user
    end
    
    can :destroy, Membership do |membership|
      group = membership.group
      # I can destroy if:
      # 1. I own the group, but it's not my membership
      # 2. I don't own the group and it is my membership
      (@user == group.owner && @user != membership.user) || (@user != group.owner && @user == membership.user)
    end
  end
  
end