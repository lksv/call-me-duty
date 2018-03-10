class EscalationRule::UserAction < EscalationRule::BaseAction
  def execute
    target.execute
  end
end
