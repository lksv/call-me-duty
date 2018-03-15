class IncidentAuditService
  class << self
    # incident:          incident,
    # event:             event,
    # escalation_policy: escalation_policy,
    # escalation_rule:   escalation_rule,
    # jid:               jid,
    # base_time:         base_time
    def emit(*log_info)
      unless block_given?
        # puts('Audit Log: %s' % log_info.inspect)
        return
      end

      result = nil
      begin
        # puts('Audit Log [starting]: %s' % log_info.inspect)
        result = yield
        # puts('Audit Log [finished]: %s' % log_info.inspect)
      rescue => err
        # puts("Failed to execute(%s): %s" % [err.to_s, log_info.inspect])
        raise
      end
      result
    end

    def emit_escalation_policy_started(incident:, escalation_policy:, base_time:)
      emit(
        event: :escalation_policy_started,
        incident: incident,
        escalation_policy: escalation_policy,
        base_time: base_time
      ) { yield }
    end

    def emit_escalation_rule_scheduled(incident:, escalation_rule:, scheduled_at:, jid:)
      emit(
        event: :escalation_rule_scheduled,
        escalation_rule: escalation_rule,
        scheduled_at: scheduled_at,
        jid: jid
      )
    end

    def emit_escalation_rule_condition_failed(incident:, escalation_rule:)
      emit(
        event: :escalation_rule_condition_failed,
        incident: incident,
        escalation_rule: escalation_rule
      )
    end

    def emit_escalation_rule_action(incident:, escalation_rule:)
      emit(
        event: :escalation_rule_action,
        incident: incident,
        escalation_rule: escalation_rule
      ) { yield }
    end

    def emit_escalation_role_worker_error(msg, error_message)
      emit(
        msg: msg,
        error_message: error_message
      )
    end

  end
end
