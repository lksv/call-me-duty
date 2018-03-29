require 'rails_helper'

RSpec.describe "calendars/edit", type: :view do
  let(:team)            { create(:team) }
  let(:calendar)        { team.calendar }

  before(:each) do
    @calendar = assign(:calendar, calendar)
    assign(:team, team)
  end

  it "renders the edit calendar form" do
    render

    assert_select "form[action=?][method=?]", calendar_path(@calendar), "post" do
      assert_select "select[name=?]", "calendar[team_id]"
    end
  end
end
