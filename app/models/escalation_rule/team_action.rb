class EscalationRule::TeamAction < EscalationRule::BaseAction
  def team
    raise(
      ::EscalationRule::InvalidTargetError,
      "Expecting Team got #{target.class}"
    ) unless Team === target

    target
  end


  def execute
    UserNotificationService.new(team.on_call).execute
  end
end
