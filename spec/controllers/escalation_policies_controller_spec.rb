require 'rails_helper'

RSpec.describe EscalationPoliciesController, type: :controller do

  let(:team)                { create(:team) }
  let(:user)                { create(:user, teams: [team]) }
  let(:escalation_policy)   { create(:escalation_policy, team: team) }

  let(:valid_attributes)    { attributes_for(:escalation_policy, team_id: team.id) }
  let(:invalid_attributes)  { {team_id: team.to_param, name: ''} }

  before(:each) do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      escalation_policy
      get :index, params: {team_id: team.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      escalation_policy
      get :show, params: {id: escalation_policy.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {team_id: team.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      escalation_policy
      get :edit, params: {id: escalation_policy.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new EscalationPolicy" do
        expect {
          post :create, params: {team_id: team.to_param, escalation_policy: valid_attributes}
        }.to change(EscalationPolicy, :count).by(1)
      end

      it "redirects to the created escalation_policy" do
        post :create, params: {team_id: team.to_param, escalation_policy: valid_attributes}
        expect(response).to redirect_to(EscalationPolicy.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {team_id: team.to_param, escalation_policy: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          name: 'new name',
          description: 'desc',
          escalation_rules_attributes: {
            "1522181894682"=>{
              _destroy: "false",
              delay: "123",
              condition_type: "not_acked",
              action_type: "user_email",
              targetable_pair: "1,User"
            }
          }
        }
      }

      it "updates the requested escalation_policy" do
        escalation_policy
        put :update, params: {id: escalation_policy.to_param, escalation_policy: new_attributes}
        escalation_policy.reload
        expect(escalation_policy.name).to eq 'new name'
        expect(escalation_policy.escalation_rules.size).to eq 1
        escalation_rule = escalation_policy.escalation_rules.first
        expect(escalation_rule.delay).to eq 123
        expect(escalation_rule.condition_type).to eq 'not_acked'
        expect(escalation_rule.action_type).to eq 'user_email'
        expect(escalation_rule.targetable).to eq User.find(1)
      end

      it "redirects to the escalation_policy" do
        escalation_policy
        put :update, params: {id: escalation_policy.to_param, escalation_policy: valid_attributes}
        expect(response).to redirect_to(escalation_policy)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        escalation_policy
        put :update, params: {id: escalation_policy.to_param, escalation_policy: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested escalation_policy" do
      escalation_policy
      expect {
        delete :destroy, params: {id: escalation_policy.to_param}
      }.to change(EscalationPolicy, :count).by(-1)
    end

    it "redirects to the escalation_policies list" do
      escalation_policy
      delete :destroy, params: {id: escalation_policy.to_param}
      expect(response).to redirect_to([team, :escalation_policies])
    end
  end

end
