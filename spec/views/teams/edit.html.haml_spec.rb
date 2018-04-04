require 'rails_helper'

RSpec.describe "teams/edit", type: :view do
  let(:team)     { create(:team) }

  before(:each) do
    @team = assign(:team, team)
  end

  it "renders the edit team form" do
    render

    assert_select "form[action=?][method=?]", team_path(@team), "post" do
      assert_select "input[name=?]", "team[name]"
    end
  end

  it "renders the edit team form for organization" do
    assign(:team, team.organization)
    render

    assert_select "form[action=?][method=?]", team_path(@team.organization), "post" do
      assert_select "input[name=?]", "team[name]"
    end
  end
end
