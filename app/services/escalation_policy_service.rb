class EscalationPolicyService
  attr_reader :escalation_policy
  def initialize(escalation_policy)
    @escalation_policy = escalation_policy
  end

  def execute(base_time: incident.created_at)
    IncidentAuditService.emit(
      event: :escalation_policy_strted,
      incident: escalation_policy.incident,
      escalation_policy: escalation_policy
    ) do
      escalation_rules.each do |escalation_rule|
        EscalationRuleWorker.new(escalation_rule.id).perform_at(
          base_time + escalation_rules.delay
        )
      end
    end
  end
end
