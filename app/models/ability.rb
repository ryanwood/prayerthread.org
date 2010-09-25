class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    @permitted_groups = user.groups
    
    alias_action :edit, :update, :destroy, :to => :modify
    
    can :create, Group
    can :read, Group, :users => { :id => @user.id }
    can :modify, Group, :owner => @user
    
    can [:index, :create], Prayer
    can :read, Prayer do |prayer|
      prayer && (prayer.user == @user || has_access_to(prayer.groups) )
    end
    can [:modify, :answer], Prayer, :user => @user
    
    can [:read, :create], Activity
    
    can [:read, :create], Intercession

    can [:read, :create], Comment
    # can :create, Comment do |comment|
    #   allowed_groups = comment.prayer.groups
    #   @user.groups.each { |g| return true if allowed_groups.include?(g) }
    #   false
    # end
    can :modify, Comment, :user => @user
    
    can :create, Invitation, :group => { :owner => @user }
    can :destroy, Invitation do |invitation|
      invitation && ( @user == invitation.group.owner || @user == invitation.recipient )
    end
    
    can [:read, :create], Membership
    can :destroy, Membership do |membership|
      group = membership.group
      # I can destroy if:
      # 1. I own the group, but it's not my membership
      # 2. I don't own the group and it is my membership
      (@user == group.owner && @user != membership.user) || (@user != group.owner && @user == membership.user)
    end
  end
  
  def has_access_to(groups)
    !(@permitted_groups & groups).empty?
  end
  
end