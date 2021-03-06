require 'rails_helper'

RSpec.describe Team, type: :model do
  let(:organization) { create(:organization, slug: 'o1') }

  let(:team)      { create(:team, slug: 's1', parent: organization) }
  let(:subteam1)  { create(:team, slug: 's2', parent: team) }
  let(:subteam2)  { create(:team, slug: 's3', parent: subteam1) }
  let(:subteam3)  { create(:team, slug: 's4', parent: subteam2) }

  let(:other_branch) { create(:team, slug: 'xxx', parent: organization) }

  let(:team_delivery_gateway) { create(:webhook_gateway, team: team) }
  let(:subteam3_delivery_gateway) { create(:webhook_gateway, team: subteam3) }

  describe 'strip_attributes' do
    it 'strip spaces and new lines from name attribute' do
      t1 = Team.new(name: "  My  Name  \n ")
      t1.valid?
      expect(t1.name).to eq 'My Name'
    end
  end

  describe 'FactoryBot.create(:team)' do
    subject { create(:team) }
    it 'creates team' do
      subject
    end

    it 'can set user' do
      t = subject
      t.users << build(:user)
    end
  end

  describe 'destroy removes all asociated models' do
    it 'removes all services and its integrations' do
      integration = create(:integration)
      subject = integration.team
      expect {
        expect {
          subject.destroy!
        }.to change(Service, :count).by(-1)
      }.to change(Integration, :count).by(-1)
    end

    it 'removes all escalation_policies with its escalation_rules' do
      escalation_rule = create(:escalation_rule)
      escalation_policy = escalation_rule.escalation_policy
      _clone = escalation_policy.find_or_build_clone.save!
      subject = escalation_policy.team

      expect {
        expect {
          subject.destroy!
        }.to change(EscalationPolicy, :count).by(-2)
      }.to change(EscalationRule, :count).by(-2)
    end

    #it 'removes all webhooks' do
    #  webhook = create(:webhook)
    #  subject = webhook.team
    #  expect {
    #    subject.destroy!
    #  }.to change(Webhook, :count).by(-1)
    #end

    it 'removes all incidents' do
      subject = create(:team)
      _incident_new = create(:incident, team: subject)
      _incident_resolved = create(:incident, status: 'resolved', team: subject)
      expect {
        subject.destroy!
      }.to change(Incident, :count).by(-2)
    end

    it 'removes all calendar and calendar_events' do
      calendar_event = create(:calendar_event)
      subject = calendar_event.team

      expect {
        expect {
          subject.destroy!
        }.to change(CalendarEvent, :count).by(-1)
      }.to change(Calendar, :count).by(-1)
    end
  end

  describe '#slugs' do
    it 'returns array of slug item on Organization' do
      expect(organization.slugs).to eq [organization.slug]
    end

    it 'returns splitted full_path' do
      expect(subteam3.slugs).to eq ['o1', 's1', 's2', 's3', 's4']
    end
  end

  describe '#organization' do
    it 'returns self for Organization' do
      expect(organization.organization).to eq organization
      expect(organization.organization.organization).to eq organization
    end

    it 'calls parent when one level nesting' do
      expect(team).to receive(:parent)
      team.organization
    end

    it 'returns organization when one level nesting' do
      expect(team.organization).to eq organization
    end
  end

  describe '#ancestor_paths' do
    it 'returns array of slog item on Organization' do
      expect(organization.ancestor_paths).to eq [organization.slug]
    end

    it 'returs all sub paths' do
      expect(subteam3.ancestor_paths).to eq [
        'o1',
        'o1/s1',
        'o1/s1/s2',
        'o1/s1/s2/s3',
        'o1/s1/s2/s3/s4'
      ]
    end
  end

  describe '#ancestors' do
    it 'returns array of self for Organization' do
      other_branch
      expect(organization.ancestors).to eq [organization]
    end

    it 'returns organization and itself for one level nesting' do
      other_branch
      expect(team.ancestors).to eq [organization, team]
    end

    it 'returns all parents' do
      other_branch
      expect(subteam3.ancestors).to eq [organization, team, subteam1, subteam2, subteam3]
    end
  end

  describe 'descendants' do
    it 'returns empty relation when no descendants' do
      expect(subteam3.descendants).to eq []
    end

    it 'returns all descendants' do
      other_branch
      subteam3
      expect(organization.descendants.count).to eq 5
      expect(organization.descendants.to_a).to include(
        other_branch,
        team,
        subteam1,
        subteam2,
        subteam3
      )
    end
  end

  describe '#visible_delivery_gateways' do
    it 'returns delivery_gateways of parent' do
      team_delivery_gateway
      expect(subteam3.visible_delivery_gateways).to include(team_delivery_gateway)
    end

    it 'returns delivery_gateways of self' do
      team_delivery_gateway
      expect(subteam3.visible_delivery_gateways).to include(subteam3_delivery_gateway)
    end


    it 'not return delivery_gateway of subteams' do
      subteam3_delivery_gateway
      expect(subteam2.visible_delivery_gateways).not_to include(subteam3_delivery_gateway)
    end
  end
end
