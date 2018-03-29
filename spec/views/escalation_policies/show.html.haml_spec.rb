require 'rails_helper'

RSpec.describe "escalation_policies/show", type: :view do
  let(:team)              { create(:team) }
  let(:escalation_policy) { create(:escalation_policy, team: team, description: 'some description') }

  before(:each) do
    @escalation_policy = assign(:escalation_policy, escalation_policy)
    assign(:team, team)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match('Name')
    expect(rendered).to match('Description')
    expect(rendered).to match('Team')

    expect(rendered).to match(escalation_policy.name)
    expect(rendered).to match(escalation_policy.description)
    expect(rendered).to match(escalation_policy.team_name)
  end
end
