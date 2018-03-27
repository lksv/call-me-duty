require 'rails_helper'

RSpec.describe "incidents/index", type: :view do
  let(:team)      { create(:team) }
  let(:user)      { create(:user, teams: [team]) }
  let(:incident1) { create(:incident, team: team) }
  let(:incident2) { create(:incident, team: team) }

  before(:each) do
    assign(:incidents, [incident1, incident2])
    allow(controller).to receive(:current_user).and_return(user)
    allow(view).to receive_messages(current_user: user)
  end

  it "renders a list of incidents" do
    render
  end
end
