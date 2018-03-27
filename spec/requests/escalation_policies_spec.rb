require 'rails_helper'

RSpec.describe "EscalationPolicies", type: :request do
  let(:team) { create(:team) }
  let(:user) { create(:user, teams: [team]) }

  before(:each) do
    sign_in user
  end

  describe "GET /escalation_policies" do
    it "works! (now write some real specs)" do
      get team_escalation_policies_path(team)
      expect(response).to have_http_status(200)
    end
  end
end
