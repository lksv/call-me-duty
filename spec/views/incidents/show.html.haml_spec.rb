require 'rails_helper'

RSpec.describe "incidents/show", type: :view do

  let(:team)              { create(:team) }
  let(:incident)          { create(:incident, team: team) }
  let(:service)           { create(:service, team: team) }
  let(:integration)       { create(:integration, service: service) }
  let(:escalation_policy) { create(:escalation_policy, team: team) }

  before(:each) do
    @incident = assign(:incident, incident)
  end

  context 'when no service, integration and escalation_policy filled' do
    it "renders attributes in <dl>" do
      render

      expect(rendered).to match('Iid')
      expect(rendered).to match('Status')
      expect(rendered).to match('Title')
      expect(rendered).to match('Description')
      expect(rendered).to match('Team')
      expect(rendered).to match('Integration')
      expect(rendered).to match('Service')
      expect(rendered).to match('Escalation policy')
      expect(rendered).to match('Priority')

      expect(rendered).to match(incident.iid.to_s)
      expect(rendered).to match(incident.status)
      expect(rendered).to match(incident.title)
      expect(rendered).to match(incident.team_name)
      expect(rendered).to match(incident.priority)
    end
  end

  context 'when service, integration and escalation_policy filled' do
    it "renders attributes in <dl>" do
      @incident.service = service
      @incident.integration = integration
      @incident.escalation_policy = escalation_policy

      assign(:incident, @incident)
      render

      expect(rendered).to match('Iid')
      expect(rendered).to match('Status')
      expect(rendered).to match('Title')
      expect(rendered).to match('Description')
      expect(rendered).to match('Team')
      expect(rendered).to match('Integration')
      expect(rendered).to match('Service')
      expect(rendered).to match('Escalation policy')
      expect(rendered).to match('Priority')

      expect(rendered).to match(incident.iid.to_s)
      expect(rendered).to match(incident.status)
      expect(rendered).to match(incident.title)
      expect(rendered).to match(incident.team_name)
      expect(rendered).to match(incident.integration_name)
      expect(rendered).to match(incident.service_name)
      expect(rendered).to match(incident.escalation_policy_name)
      expect(rendered).to match(incident.priority)
    end
  end
end
