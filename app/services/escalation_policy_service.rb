class EscalationPolicyService
  attr_reader :escalation_policy, :incident
  def initialize(escalation_policy, incident)
    @escalation_policy = escalation_policy
    @incident = incident
  end

  def execute(base_time: incident.created_at)
    clone = escalation_policy.find_or_build_clone
    clone.save! unless clone.persisted?
    IncidentAuditService.emit_escalation_policy_started(
      incident: incident,
      base_time: base_time,
      escalation_policy: clone
    ) do

      clone.escalation_rules.each do |escalation_rule|
        scheduled_at = base_time + escalation_rule.delay.second

        jid = EscalationRuleWorker.perform_at(
          scheduled_at,
          escalation_rule.id,
          incident.id
        )

        IncidentAuditService.emit_escalation_rule_scheduled(
          incident: incident,
          escalation_rule: escalation_rule,
          scheduled_at: scheduled_at,
          jid: jid
        )
      end
    end
  end
end
