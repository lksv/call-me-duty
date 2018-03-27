require 'rails_helper'

RSpec.describe "incidents/edit", type: :view do
  let(:team)      { create(:team) }
  let(:user)      { create(:user, teams: [team]) }
  let(:incident)  { create(:incident, team: team) }

  before(:each) do
    @team = assign(:team, team)
    @incident = assign(:incident, incident)

    allow(controller).to receive(:current_user).and_return(user)
    allow(view).to receive_messages(current_user: user)
  end

  it "renders the edit incident form" do
    render

    assert_select "form[action=?][method=?]", incident_path(@incident), "post" do
    end
  end
end
