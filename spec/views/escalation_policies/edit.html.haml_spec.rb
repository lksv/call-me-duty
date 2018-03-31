require 'rails_helper'

RSpec.describe "escalation_policies/edit", type: :view do
  let(:team)              { create(:team) }
  let(:escalation_policy) { create(:escalation_policy, team: team) }

  before(:each) do
    @escalation_policy = assign(:escalation_policy, escalation_policy)
    assign(:team, team)
  end

  it "renders the edit escalation_policy form" do
    render

    assert_select "form[action=?][method=?]", team_escalation_policy_path(team, @escalation_policy), "post" do
      assert_select "input[name=?]", "escalation_policy[name]"
      assert_select "textarea[name=?]", "escalation_policy[description]"
    end
  end

  it "renders the edit escalation_policy form" do
    assign(:team, team.organization)
    render

    assert_select "form[action=?][method=?]", team_escalation_policy_path(team.organization, @escalation_policy), "post" do
      assert_select "input[name=?]", "escalation_policy[name]"
      assert_select "textarea[name=?]", "escalation_policy[description]"
    end
  end
end
