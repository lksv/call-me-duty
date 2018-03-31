require 'rails_helper'

RSpec.describe "Integrations", type: :request do
  let(:team) { create(:team) }
  let(:user) { create(:user, teams: [team]) }
  let(:service) { create(:service, team: team) }

  before(:each) do
    sign_in user
  end


  describe "GET /integrations" do
    it "works! (now write some real specs)" do
      get team_service_integrations_path(team, service)
      expect(response).to have_http_status(200)
    end
  end
end
