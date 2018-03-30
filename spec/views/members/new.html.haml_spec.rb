require 'rails_helper'

RSpec.describe "members/new", type: :view do
  let(:member) { build(:member) }
  let(:team) { member.team }

  before(:each) do
    assign(:member, member)
    assign(:team, team)
  end

  it "renders new member form" do
    render

    assert_select "form[action=?][method=?]", team_members_path(team), "post" do
      assert_select "select[name=?]", "member[access_level]"
      assert_select "select[name=?]", "member[user_id]"
    end
  end
end
