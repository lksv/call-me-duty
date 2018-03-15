class EscalationRule::OnCallVoiceCallAction < EscalationRule::BaseAction
  def user
    incident.team.current_oncall_user
  end

  def execute
    VoiceCallIncidentNotificationService.new(
      incident: incident,
      user: user,
      source: source
    ).execute
  end
end
