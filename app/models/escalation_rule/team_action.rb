class EscalationRule::TeamAction < EscalationRule::BaseAction
  def execute
    UserNotification.new(team.on_call).execute
  end
end
