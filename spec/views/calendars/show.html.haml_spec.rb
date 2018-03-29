require 'rails_helper'

RSpec.describe "calendars/show", type: :view do
  let(:team)            { create(:team) }
  let(:calendar)        { create(:calendar, team: team) }

  before(:each) do
    @calendar = assign(:calendar, calendar)
    assign(:team, team)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match('Team')
    expect(rendered).to match(team.name)
    expect(rendered).to match('Currently on call')
    expect(rendered).to match('nobody on call')
  end
end
