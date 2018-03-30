require 'rails_helper'

RSpec.describe "members/index", type: :view do
  let(:team) { create(:team) }
  let(:member1) { create(:member, team: team) }
  let(:member2) { create(:member, team: team) }

  before(:each) do
    assign(:members, [member1, member2])
    assign(:team, team)
  end

  it "renders a list of members" do
    render
    assert_select 'tr>td', text: 'Show', count: 2
    assert_select 'tr>td', text: member1.user_name, count: 1
    assert_select 'tr>td', text: member2.user_name, count: 1
  end
end
