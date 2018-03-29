require 'rails_helper'

RSpec.describe "calendars/index", type: :view do
  let(:team)            { create(:team) }
  let(:calendar1)       { create(:calendar, team: team) }
  let(:calendar2)       { create(:calendar, team: team) }

  before(:each) do
    assign(:calendars, [calendar1, calendar2])
  end

  it "renders a list of calendars" do
    render
    assert_select 'tr>td', text: 'Show', :count => 2
    assert_select 'tr>td', text: team.name, :count => 2
  end
end
