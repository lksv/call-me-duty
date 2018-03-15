require 'rails_helper'

RSpec.describe Team, type: :model do
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
end
