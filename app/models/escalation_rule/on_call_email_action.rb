class EscalationRule::OnCallEmailAction < EscalationRule::BaseAction
  def user
    incident.team.current_oncall_user
  end

  def execute
    EmailIncidentNotificationService.new(
      incident: incident,
      user: user,
      source: source
    ).execute
  end
end
