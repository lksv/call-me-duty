require 'rails_helper'

RSpec.describe "teams/index", type: :view do
  let(:team1)     { create(:team) }
  let(:team2)     { create(:team) }

  before(:each) do
    @team = assign(:teams, [team1, team2])
  end

  it "renders a list of teams" do
    render
    assert_select 'tr>td', text: team1.name, :count => 1
    assert_select 'tr>td', text: team2.name, :count => 1
    assert_select 'tr>td', text: 'Show', :count => 2
  end
end
