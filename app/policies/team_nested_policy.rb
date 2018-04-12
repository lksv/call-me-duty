class TeamNestedPolicy < ApplicationPolicy

  def modify_level
    Member::MANAGER
  end

  def index?
    # we suppose to obtain a Team instance in record attribute
    record&.visible_for_user?(user)
  end

  def show?
    record&.team&.visible_for_user?(user)
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
    record.team.access_level_for_user(user) >= modify_level
  end
end
