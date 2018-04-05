class TeamPolicy < ApplicationPolicy

  def index?
    # TODO user is logged && user is part of organization or organization has
    # at least one public project
    # ...does it make sence?
    user
  end

  def show?
    record && (
      false || # record.visibility_level > 10
      user.visible_teams.to_a.include?(record)
    )
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
      scope
    end
  end

  private

  def modifiable
    user.team_access_level(record) >= Member::AccessLevels[:manager]
  end
end
