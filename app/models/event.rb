class Event
  attr_reader :type, :condition, :prayer, :filtered_users, :mailer

  TYPES = [:created, :answered]
  MAP = { :created => [Prayer, Comment], :answered => [Prayer] }
  
  def initialize(type, source)
    raise ArgumentError unless TYPES.include?(type)
    raise ArgumentError, "There is no '#{type}' notification configured for the #{source.class} class." unless MAP[type].include?(source.class)
    @type = type
    @source = source
    @condition = "#{@source.class.to_s.underscore}_#{@type}"
    @mailer = @condition.to_sym

    if @source.is_a?(Comment)
      if @source.user == @source.prayer.user
        @condition = "comment_from_originator"
      else
        @condition = "comment_to_originator"
      end
    end

    @prayer = @source.is_a?(Prayer) ? @source : @source.prayer
    @filtered_users = [@source.user]
  end

  def audience
    memberships = Membership.scoped
    memberships = memberships.where("group_id IN (?) AND notify_on_#{@condition} = ?", @prayer.groups, true)
    memberships = memberships.where("user_id = ?", @prayer.user) if @condition == 'comment_to_originator'
    memberships.map { |m| m.user }.uniq - @filtered_users
  end
end
