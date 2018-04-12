class IncidentPolicy < TeamNestedPolicy

  def modify_level
    Member::RESPONDER
  end

  def destroy?
    record.team.access_level_for_user(user) >= Member::SYSTEM_ADMIN
  end

  # def permitted_attributes_for_create
  #   permitted_attributes_for_edit + [ :team_id ]
  # end

  def permitted_attributes
    [
      :status,
      :title,
      :description,
      :service_id,
      :priority
    ]
  end
end
