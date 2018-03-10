class EscalationRule::BaseAction
  attr_reader :target, :incident

  def initialize(target, incident)
    @target = target
    @incident = incident
  end

  def title
    "Incident: #{incident.title}"
  end

  def message(format: :long)
    incident.description
  end
end
