class TeamNestedPolicy < ApplicationPolicy

  def modify_level
    :manager
  end

  def index?
    # for #index? we suppose to obtain a Team instance in record attribute
    record && user.visible_teams.to_a.include?(record)
  end

  def show?
    #(team.visibility_level > TODO) ||
      record.team && user.visible_teams.to_a.include?(record.team)
  end

  def create?
    modifiable
  end

  def update?
    modifiable
  end

  def destroy?
    modifiable
  end

  class Scope < Scope
    def resolve
      scope.joins(team: :members).where(members: { team_id: user.visible_teams })
    end
  end

  private

  def modifiable
    user.team_access_level(record.team) >= Member::AccessLevels[modify_level]
  end
end
