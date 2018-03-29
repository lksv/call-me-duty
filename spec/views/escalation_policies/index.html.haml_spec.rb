require 'rails_helper'

RSpec.describe "escalation_policies/index", type: :view do
  let(:team)              { create(:team) }
  let(:escalation_policy1) { create(:escalation_policy, team: team) }
  let(:escalation_policy2) { create(:escalation_policy, team: team) }

  before(:each) do
    assign(:escalation_policies, [escalation_policy1, escalation_policy2])
    assign(:team, team)
  end

  it "renders a list of escalation_policies" do
    render
    assert_select 'tr>td', text: 'Show', :count => 2
    assert_select 'tr>td', text: escalation_policy1.name, :count => 1
    assert_select 'tr>td', text: escalation_policy2.name, :count => 1
  end
end
