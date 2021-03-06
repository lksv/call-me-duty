class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy, :calendar]

  # GET /teams
  # GET /teams.json
  def index
    @teams = current_user.teams
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team.becomes(Team), notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team.becomes(Team), notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def calendar
    @calendar = @team.calendar
    @calendar_events = @calendar.calendar_events.includes(:user)

    render 'calendars/show'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find_by(full_path: params[:full_path] || params[:id])
    end

    # TODO I cannot set any parent_id, but only of organization the
    # current_user is a member of
    def team_params
      params.require(:team).permit(:name, :visibility_level, :parent_id)
    end
end
