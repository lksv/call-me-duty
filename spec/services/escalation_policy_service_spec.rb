require 'rails_helper'

RSpec::Matchers.define :escalation_rule_scheduled do |x|
  match do |actual|
    (actual[:event] == escalation_rule_scheduled) and
      (actual[:scheduled_at] == x[:scheduled_at])
  end
end


RSpec.describe EscalationPolicyService do
  let(:escalation_rule3) { create(:escalation_rule, delay: 3) }
  let(:escalation_rule5) { create(:escalation_rule, delay: 5) }
  let(:escalation_policy) do
    create(
      :escalation_policy,
      escalation_rules: [escalation_rule3, escalation_rule5]
    )
  end
  let(:incident) { create(:incident, team: escalation_policy.team) }
  let(:base_time) { Time.new(2017,1,1) }

  describe '#execute' do
    it 'emits :escalation_policy_strted on clone' do
      expect(IncidentAuditService).to receive(:emit_escalation_policy_started) do |event|
        expect(event[:escalation_policy].clonned_from).to eq escalation_policy
        expect(event[:incident]).to eq incident
      end
      described_class.new(escalation_policy, incident)
        .execute(base_time: base_time)
    end

    it 'emits :escalation_rule_scheduled for each escalation_rule' do
      clone = escalation_policy.find_or_build_clone
      clone.save!

      expect(IncidentAuditService).to(
        receive(:emit_escalation_rule_scheduled).with(hash_including(
          incident: incident,
          escalation_rule: clone.escalation_rules.first,
          scheduled_at: base_time + 3.seconds
        )).once.ordered
      )
      expect(IncidentAuditService).to(
        receive(:emit_escalation_rule_scheduled).with(hash_including(
          incident: incident,
          escalation_rule: clone.escalation_rules.last,
          scheduled_at: base_time + 5.seconds
        )).once.ordered
      )


      described_class.new(escalation_policy, incident)
        .execute(base_time: base_time)
    end

    it 'schedules backgroud job for each escalation_rule' do
      expect {
        described_class.new(escalation_policy, incident)
          .execute(base_time: base_time)
      }.to change(EscalationRuleWorker.jobs, :size).by(2)
    end

  end
end
