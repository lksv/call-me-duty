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


  describe 'readonly' do
    let(:escalation_rule) { create(:escalation_rule) }
    let(:prime) { create(:escalation_policy, escalation_rules: [escalation_rule]) }
    let(:clone) { c = prime.find_or_build_clone; c.new_record? && c.save!; c }

    it 'cannot change any escalation_rule of clone' do
      clone_escalation_rule = clone.escalation_rules.first
      clone_escalation_rule.delay = 1000
      expect {
        clone_escalation_rule.save!
      }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end

  end


  let(:incident) { double('incident instance') }

  describe '#condition' do
    it 'returns an instance of given condition' do
      subject = build(:escalation_rule, condition_type: 'true')
      expect(subject.condition(incident)).to be_a(EscalationRule::TrueCondition)
    end

    it 'passes incident to condition instance' do
      subject = build(:escalation_rule, condition_type: 'true')
      expect(subject.condition(incident).incident).to eq incident
    end
  end

  describe '#action' do
    let(:target) { build(:user) }

    it 'returns an instance of given action' do
      subject = build(:escalation_rule, action_type: 'user', targetable: target)
      expect(subject.action(incident)).to be_a(EscalationRule::UserAction)
    end

    it 'passes target and incident to action instance' do
      subject = build(:escalation_rule, action_type: 'user', targetable: target)
      expect(subject.action(incident).incident).to eq incident
      expect(subject.action(incident).target).to eq target
    end
  end
end
