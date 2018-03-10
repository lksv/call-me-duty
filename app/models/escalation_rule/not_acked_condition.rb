class EscalationRule::NotAckedCondition < EscalationRule::BaseCondition
  def execute
    super && !incident.acked?
  end
end
