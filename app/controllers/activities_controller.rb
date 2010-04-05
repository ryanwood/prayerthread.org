class ActivitiesController < ApplicationController
  before_filter :authenticate
  load_and_authorize_resource :nested => :prayer
  
  def index
    @activities = Activity.find_all_grouped(current_user)
    @activities_exist = @activities.find { |k, v| !v.empty? }
  end
end
