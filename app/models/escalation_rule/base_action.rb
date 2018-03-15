class EscalationRule::BaseAction
  attr_reader :target, :incident, :source

  def initialize(target, incident, source)
    @target = target
    @incident = incident
    @source = source
  end

  def title
    "Incident: #{incident.title}"
  end

  def message(format: :long)
    incident.description
  end
end
