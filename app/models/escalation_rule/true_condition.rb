class EscalationRule::TrueCondition < EscalationRule::BaseCondition
  # event TrueCondition could return false when the incident is resolved.
  #
  # Resolved incident means generally, there are no further actions!
  def execute
    !incident.resolved?
  end
end
