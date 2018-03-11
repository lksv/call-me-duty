class EscalationRule::WebhookAction < EscalationRule::BaseAction
  def webhook
    raise(
      ::EscalationRule::InvalidTargetError,
      "Expecting User got #{target.class}"
    ) unless Webhook === target

    target
  end

  def execute
    WebhookService.new(webhook).execute
  end
end
