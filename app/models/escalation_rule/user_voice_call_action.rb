class EscalationRule::UserVoiceCallAction < EscalationRule::BaseAction
  def user
    raise(
      ::EscalationRule::InvalidTargetError,
      "Expecting User got #{target.class}"
    ) unless User === target

    target
  end

  def execute
    VoiceCallIncidentNotificationService.new(
      incident: incident,
      user: user,
      source: source
    ).execute
  end
end
