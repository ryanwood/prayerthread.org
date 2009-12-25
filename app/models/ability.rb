class Ability
  include CanCan::Ability

  def initialize(user)
    
    can :manage, Prayer do |action, prayer|
      prayer && prayer.user == user
    end
    
    can :destroy, Invitation do |invitation|
      invitation && invitation.group.owner == user
    end
    
  end
  
end