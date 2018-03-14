class EscalationRuleWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :escalation_rule, :retry => 3, :backtrace => true

  sidekiq_retry_in do |count|
    10 * (count + 1) # (i.e. 10, 20, 30, 40, 50)
  end

  sidekiq_retries_exhausted do |msg, e|
    # TODO
    IncidentAuditService.emit_escalation_role_worker_error(
      msg: msg['args'],
      error_message: msg['error_message']
    )
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  attr_accessor :escalation_rule, :incident

  def perform(escalation_rule_id, incident_id)
    @escalation_rule = EscalationRule.find(escalation_rule_id)
    @incident = Incident.find(incident_id)

    return unless process_condition
    process_action
  end

  def process_condition
    unless escalation_rule.condition(incident).execute
      IncidentAuditService.emit_escalation_rule_condition_failed(
        incident: incident,
        escalation_rule: escalation_rule
      )
      return false
    end
    true
  end

  def process_action
    IncidentAuditService.emit_escalation_rule_action(
      incident: incident,
      escalation_rule: escalation_rule
    ) { escalation_rule.action(incident).execute }
  end
end
