class EscalationRule::WebhookAction < EscalationRule::BaseAction
  def webhook
    raise(
      ::EscalationRule::InvalidTargetError,
      "Expecting User got #{target.class}"
    ) unless WebhookGateway === target

    target
  end

  def execute
    WebhookNotificationService.new(
      incident: incident,
      gateway: webhook,
      source: source
    ).execute
  end
end
