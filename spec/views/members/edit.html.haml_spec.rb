require 'rails_helper'

RSpec.describe "members/edit", type: :view do
  let(:member) { create(:member) }
  let(:team) { member.team }

  before(:each) do
    @member = assign(:member, member)
    assign(:team, team)
  end

  it "renders the edit member form" do
    render

    assert_select "form[action=?][method=?]", member_path(@member), "post" do
      assert_select "select[name=?]", "member[access_level]"
      assert_select "select[name=?]", "member[user_id]", count: 0
    end
  end
end
