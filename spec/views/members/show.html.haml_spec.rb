require 'rails_helper'

RSpec.describe "members/show", type: :view do
  let(:member) { create(:member) }
  let(:team) { member.team }

  before(:each) do
    @member = assign(:member, member)
    assign(:team, team)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match('User')
    expect(rendered).to match(member.user_name)
  end
end
