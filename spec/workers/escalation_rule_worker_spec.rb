require 'rails_helper'

RSpec.describe EscalationRuleWorker do
  let(:escalation_rule)   { create(:escalation_rule) }
  let(:escalation_policy) { escalation_rule.escalation_policy }
  let(:incident)   { create(:incident, team: escalation_policy.team) }

  subject { described_class.new }

  describe '#perform' do
    it 'do not run .process_action when .process_condition return falsey' do
      expect(subject).to receive(:process_condition).and_return(false)
      expect(subject).to_not receive(:process_action)
      subject.perform(escalation_rule.id, incident.id)
    end

    it 'run .process_action when .process_condition succeed' do
      expect_any_instance_of(described_class).to receive(:process_condition).and_return(true)
      expect_any_instance_of(described_class).to receive(:process_action) { }
      subject.perform(escalation_rule.id, incident.id)
    end
  end

  subject do
    s = described_class.new
    s.incident = incident
    s.escalation_rule = escalation_rule
    s
  end

  describe '#process_condition' do
    it 'evals escalation_rule.condition' do
      condition = double('EscalationRule Condition')
      expect(escalation_rule).to(
        receive(:condition).with(incident).and_return(condition)
      )
      expect(condition).to receive(:execute).and_return(false)
      subject.process_condition
    end

    it 'emits escalation_rule_condition_failed when conditin is not met' do
      condition = double('EscalationRule Condition', execute: false)
      expect(escalation_rule).to(
        receive(:condition).with(incident).and_return(condition)
      )
      expect(IncidentAuditService).to(
        receive(:emit_escalation_rule_condition_failed).with(hash_including(
          incident: incident,
          escalation_rule: escalation_rule
        ))
      )
      subject.process_condition
    end
  end

  describe '#process_action' do
    it 'emits escalation_rule_action' do
      expect(IncidentAuditService).to(
        receive(:emit_escalation_rule_action).with(hash_including(
          incident: incident,
          escalation_rule: escalation_rule
        )) { }
      )
      subject.process_action
    end

    it 'calls #execute on rules action' do
      fake_action = double('fake_action')
      expect(fake_action).to receive(:execute)
      expect(escalation_rule).to receive(:action).with(incident).and_return(fake_action)
      subject.process_action
    end
  end
end
