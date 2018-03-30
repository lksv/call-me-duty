require 'rails_helper'

RSpec.describe "Members", type: :request do
  let(:team) { create(:team) }
  let(:user) { create(:user, teams: [team]) }

  before(:each) do
    sign_in user
  end

  describe "GET /members" do
    it "works! (now write some real specs)" do
      get team_members_path(team)
      expect(response).to have_http_status(200)
    end
  end
end
