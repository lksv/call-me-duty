require 'rails_helper'

RSpec.describe EscalationRule, type: :model do
  describe '.validates' do
    it 'validates presence of delay' do
      subject = build(:escalation_rule, delay: nil)
      subject.valid?
      expect(subject.errors[:delay].size).to eq 1
    end
  end

  describe 'FactoryBot.create(:escalation_rule)' do
    subject { create(:escalation_rule) }
    it 'creates an EscalationRule' do
      expect(subject.valid?).to be true
      expect(
        subject.escalation_policy.escalation_rules.include?(subject)
      ).to be true
    end
  end


  describe 'associations' do
    it 'it sets an EscalationPolicy association' do
      subject = create(:escalation_rule, action_type: 'user')
      expect(subject.escalation_policy.escalation_rules).to include(subject)
    end
  end


  let(:incident) { double('incident instance') }

  describe '#condition' do
    it 'returns an instance of given condition' do
      subject = build(:escalation_rule, condition_type: 'true')
      allow(subject).to receive(:incident).and_return(incident)
      expect(subject.condition).to be_a(EscalationRule::TrueCondition)
      expect(subject.condition.incident).to eq incident
    end
  end

  describe '#action' do
    let(:target) { build(:user) }

    it 'returns an instance of given action' do
      subject = build(:escalation_rule, action_type: 'user', target: target)
      allow(subject).to receive(:incident).and_return(incident)
      expect(subject.action).to be_a(EscalationRule::UserAction)
      expect(subject.action.incident).to eq incident
      expect(subject.action.target).to eq target
    end
  end
end
