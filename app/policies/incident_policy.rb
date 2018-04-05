class IncidentPolicy < TeamNestedPolicy
  def destroy?
    # TODO
    user.team_access_level(record.team) >= Member::AccessLevels[:system_admin]
  end

  def permitted_attributes_for_create
    permitted_attributes_for_edit + [ :team_id ]
  end

  def permitted_attributes_for_edit
    [
      :status,
      :title,
      :description,
      :service_id,
      :priority
    ]
  end
end
