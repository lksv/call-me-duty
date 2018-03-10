class IncidentAuditService
  def self.emit(
    event:,
    incident:,
    escalation_policy: nil,
    escalation_rule: nil
  )
    #TODO!
    if block_given?
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
    end
    result
  end

  private

  def log_info
    {
      incident:          incident,
      event:             event,
      escalation_policy: escalation_policy,
      escalation_rule:   escalation_rule
    }
  end
end
