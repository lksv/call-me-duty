require 'rails_helper'

RSpec.describe "calendars/new", type: :view do
  let(:team)            { create(:team) }
  let(:calendar)        { build(:calendar, team: team) }

  before(:each) do
    @calendar = assign(:calendar, calendar)
    assign(:team, team)
  end

  it "renders new calendar form" do
    render

    assert_select "form[action=?][method=?]", team_calendars_path(team), "post" do
      assert_select "select[name=?]", "calendar[team_id]"
    end
  end
end
