class HomeController < ApplicationController
  #skip_before_action :authenticate_user!, only: [:index]

  before_action :redirect_unlogged_user, 	if: -> { p current_user; current_user.nil? }
  before_action :redirect_logged_user, 		if: -> { current_user.present? }

  def index
  end

  private

  def redirect_unlogged_user
    redirect_to(new_user_session_path)
  end

  def redirect_logged_user
    flash.keep
    redirect_to(team_incidents_path(current_user&.default_team))
  end

end
