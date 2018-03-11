class EscalationRule::UserAction < EscalationRule::BaseAction
  def user
    raise(
      ::EscalationRule::InvalidTargetError,
      "Expecting User got #{target.class}"
    ) unless User === target

    target
  end

  def execute
    UserNotificationService.new(user).execute
  end
end
