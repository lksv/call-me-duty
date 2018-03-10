class EscalationRule::UserAction < EscalationRule::BaseAction
  def execute
    UserNotification.new(target).execute
  end
end
