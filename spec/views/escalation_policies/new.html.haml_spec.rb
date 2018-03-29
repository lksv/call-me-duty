require 'rails_helper'

RSpec.describe "escalation_policies/new", type: :view do
  let(:team)              { create(:team) }
  let(:escalation_policy) { build(:escalation_policy, team: team) }

  before(:each) do
    assign(:escalation_policy, escalation_policy)
    assign(:team, team)
  end

  it "renders new escalation_policy form" do
    render

    assert_select "form[action=?][method=?]", team_escalation_policies_path(team), "post" do
      assert_select "input[name=?]", "escalation_policy[name]"
      assert_select "textarea[name=?]", "escalation_policy[description]"
    end
  end
end
