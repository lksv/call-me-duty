class EscalationRuleWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :escalation_rule, :retry => 3, :backtrace => true

  attr_reader :escalation_rule

  def perform(escalation_rule_id)
    @escalation_rule = EscalationRule.find(escalation_rule_id)

    return unless process_condition
    process_action
  end

  def process_condition
    unless escalation_rule.condition.eval
      IncidentAuditService.log_event(
        event: :escalation_rule_condition_failed,
        incident: escalation_rule.incident,
        escalation_rule: escalation_rule
      )
      return false
    end
    true
  end

  def process_action
    IncidentAuditService.log_event(
      event: :escalation_rule_action,
      incident: escalation_rule.incident,
      escalation_rule: escalation_rule
    ) { escalation_rule.action.eval }
  end
end
