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
