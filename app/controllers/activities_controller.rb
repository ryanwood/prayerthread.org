class ActivitiesController < ApplicationController
  before_filter :authorize
  authorize_resource

  def index
    @activities = Activity.find_all_grouped(current_user)
    @activities_exist = @activities.find { |k, v| !v.empty? }
  end
end
