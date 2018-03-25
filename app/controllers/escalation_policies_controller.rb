class EscalationPoliciesController < ApplicationController
  before_action :set_team, only: [:index, :new, :create]
  before_action :set_escalation_policy, only: [:show, :edit, :update, :destroy]
  before_action :set_targetables, only: [:new, :create, :edit, :update]

  # GET /escalation_policies
  # GET /escalation_policies.json
  def index
    @escalation_policies = @team.escalation_policies.all
  end

  # GET /escalation_policies/1
  # GET /escalation_policies/1.json
  def show
  end

  # GET /escalation_policies/new
  def new
    @escalation_policy = @team.escalation_policies.new
  end

  # GET /escalation_policies/1/edit
  def edit
  end

  # POST /escalation_policies
  # POST /escalation_policies.json
  def create
    @escalation_policy = @team.escalation_policies.new(escalation_policy_params)

    respond_to do |format|
      if @escalation_policy.save
        format.html { redirect_to @escalation_policy, notice: 'Escalation policy was successfully created.' }
        format.json { render :show, status: :created, location: @escalation_policy }
      else
        format.html { render :new }
        format.json { render json: @escalation_policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /escalation_policies/1
  # PATCH/PUT /escalation_policies/1.json
  def update
    respond_to do |format|
      if @escalation_policy.update(escalation_policy_params)
        format.html { redirect_to @escalation_policy, notice: 'Escalation policy was successfully updated.' }
        format.json { render :show, status: :ok, location: @escalation_policy }
      else
        format.html { render :edit }
        format.json { render json: @escalation_policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /escalation_policies/1
  # DELETE /escalation_policies/1.json
  def destroy
    @escalation_policy.destroy
    respond_to do |format|
      format.html { redirect_to escalation_policies_url, notice: 'Escalation policy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_escalation_policy
      @escalation_policy = EscalationPolicy.find(params[:id])
      @team = @escalation_policy.team
    end

    def set_team
      @team = current_user.teams.find(params[:team_id])
    end

    def set_targetables
      @targetables =
        current_user.visible_users.map { |u| [u.name, [u.id, 'User'].join(',')] } +
        current_user.visible_delivery_gateways.map { |u| [u.name, [u.id, u.type].join(',')] }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def escalation_policy_params
      params.require(:escalation_policy).permit(
        :name,
        :description,
        escalation_rules_attributes: [
          :id,
          :_destroy,
          :delay,
          :condition_type,
          :action_type,
          :targetable_pair
        ])
    end
end
