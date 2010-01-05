class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    @permitted_groups = user.groups
    
    alias_action :edit, :update, :destroy, :to => :modify
    
    can [:index, :create], Prayer
    can :show, Prayer do |prayer|
      prayer && (prayer.user == @user || has_access_to(prayer.groups) )
    end
    can :modify, Prayer do |prayer|
      prayer && prayer.user == @user
    end

    can [:read, :create], Comment
    # can :create, Comment do |comment|
    #   allowed_groups = comment.prayer.groups
    #   @user.groups.each { |g| return true if allowed_groups.include?(g) }
    #   false
    # end
    can :modify, Comment do |comment|
      comment && comment.user == @user
    end
    
    can :destroy, Invitation do |invitation|
      invitation && ( @user == invitation.group.owner || @user == invitation.recipient )
    end
    
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