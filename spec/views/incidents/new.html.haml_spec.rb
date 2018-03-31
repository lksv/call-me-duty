require 'rails_helper'

RSpec.describe "incidents/new", type: :view do
  let(:team) { create(:team) }
  let(:user) { create(:user, teams: [team]) }

  before(:each) do
    assign(:incident, Incident.new())
    assign(:team, team)

    sign_in user
  end

  it "renders new incident form" do
    render

    assert_select "form[action=?][method=?]", team_incidents_path(team), "post" do
    end
  end

  it "renders new incident form for organizations incident" do
    assign(:team, team.organization)
    render
    assert_select "form[action=?][method=?]", team_incidents_path(team.organization), "post" do
    end
  end
end
