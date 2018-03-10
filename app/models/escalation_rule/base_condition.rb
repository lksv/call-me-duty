class EscalationRule::BaseCondition
  attr_reader :incident

  def initialize(incident)
    @incident = incident
  end

  # false when incident is snoozed or resolved
  def execute
    !incident.resolved? && !incident.snoozed?
  end
end
