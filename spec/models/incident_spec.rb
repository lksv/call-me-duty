require 'rails_helper'

RSpec.describe Incident, type: :model do
  subject { create(:incident) }
  describe 'FactoryBot.create(:incident)' do
    it 'creates incident' do
      subject
      expect(subject.team).to_not be nil
    end
  end

  describe 'validations' do
    it 'validates that incident belongs to the service' do
      subject.integration = create(:integration)
      subject.service = create(:service)
      expect(subject.valid?).to be false
      expect(subject.errors[:integration].size).to eq 1
    end
  end

  describe 'before_validation' do
    it 'sets service when integration is defined' do
      subject.integration = create(:integration)
      subject.valid?
      expect(subject.service).to eq subject.integration.service
    end
  end

  describe '#readonly?' do
    let(:resolved_incident) { create(:incident, status: 'resolved') }
    let(:created_incident)  { create(:incident, status: 'created') }
    let(:unpersisted_incident)  { build(:incident) }

    it 'return true when incident is resolved' do
      expect(resolved_incident.readonly?).to be true
    end

    it 'return false for resolved incident when team is marked for destruction' do
      resolved_incident.team.marked_for_destruction = true
      expect(resolved_incident.readonly?).to be false
    end


    it 'return false when incident not resolved' do
      expect(created_incident.readonly?).to be false
    end

    it 'return false when incident is not persisted' do
      expect(unpersisted_incident.readonly?).to be false
    end
  end


  describe 'associations' do
    it 'it sets an team association' do
      subject = create(:incident)
      expect(subject.team.incidents).to include(subject)
    end

    it 'it sets an integration association' do
      subject = create(:incident, integration: create(:integration))
      expect(subject.integration.incidents).to include(subject)
    end

    it 'it sets an service association' do
      subject = create(:incident, service: create(:service))
      expect(subject.service.incidents).to include(subject)
    end

    it 'it sets an escalation_policy association' do
      subject = build(:incident)
      subject.escalation_policy = create(:escalation_policy, team: subject.team)
      subject.save!
      expect(subject.escalation_policy.incidents).to include(subject)
    end

    it 'incident stays when integration is deleted' do
      subject = create(:incident, service: create(:service))
      subject.service.destroy!
      subject.reload
    end

    it 'incident stays when service is deleted' do
      subject = create(:incident, integration: create(:integration))
      subject.integration.destroy!
      subject.reload
    end

    it 'destroys Incident when team is destroyed' do
      subject
      team = subject.team
      expect {
        team.destroy!
      }.to change(Incident, :count).by(-1)
    end
  end
end
