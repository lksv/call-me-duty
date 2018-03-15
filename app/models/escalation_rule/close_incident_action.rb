class EscalationRule::CloseIncidentAction < EscalationRule::BaseAction
  def user
    raise(
      ::EscalationRule::InvalidTargetError,
      "Expecting User got #{target.class}"
    ) unless User === target

    target
  end

  def execute
    # TODO make IncidentService and delegate call there?
    # TODO write to audit log
    incident.status = :resolved
    incident.save!
  end
end
