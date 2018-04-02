class TeamNestedPolicy < ApplicationPolicy

  def index?
    # fo #index? we suppose to obtain a Team in record attribute
    record.team && user.visible_teams.to_a.include?(record)
  end

  def show?
    record.team && user.visible_teams.to_a.include?(record.team)
  end

  def create?
    user.team_access_level(record.team) >= Member::AccessLevels[:Responder]
  end

  def update?
    user.team_access_level(record.team) >= Member::AccessLevels[:Responder]
  end

  def destroy?
    user.team_access_level(record.team) >= Member::AccessLevels[:Responder]
  end

  class Scope < Scope
    def resolve
      scope.joins(team: :members).where(members: { team_id: user.visible_teams })
    end
  end
end
