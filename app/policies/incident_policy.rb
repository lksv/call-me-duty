class IncidentPolicy < TeamNestedPolicy
  def destroy?
    user.team_access_level(record.team) >= Member::AccessLevels[:SystemAdmin]
  end
end
