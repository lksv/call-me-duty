require 'rails_helper'

RSpec.describe "teams/index", type: :view do
  let(:team1)     { create(:team) }
  let(:team2)     { create(:team) }

  before(:each) do
    @team = assign(:teams, [team1, team2])
  end

  it "renders a list of teams" do
    render
    expect(rendered).to match(team1.name)
    expect(rendered).to match(team2.name)
    assert_select 'tr>td', text: 'Show', :count => 2
  end
end
