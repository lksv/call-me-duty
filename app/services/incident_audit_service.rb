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
        puts(log_info.inspect)
        return
      end

      result = nil
      begin
        puts("Starting %s" % log_info.inspect)
        result = yield
        puts("Finished %s" % log_info.inspect)
      rescue => err
        puts("Failed to execute(%s): %s" % [err.to_s, log_info.inspect])
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
        escalation_rule: escalation_rule,
        scheduled_at: scheduled_at,
        jid: jid
      )
    end

  end
end
