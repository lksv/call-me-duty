# == Schema Information
#
# Table name: members
#
#  id            :integer          not null, primary key
#  type          :string
#  user_id       :integer
#  team_id       :integer
#  access_level  :integer          not null
#  created_by_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_members_on_created_by_id  (created_by_id)
#  index_members_on_team_id        (team_id)
#  index_members_on_user_id        (user_id)
#

class Member < ApplicationRecord

  MEMBER       = 1
  OBSERVER     = 10
  RESPONDER    = 30
  MANAGER      = 60
  SYSTEM_ADMIN = 100

  TeamAccessLevels = {
    observer:     OBSERVER,
    responder:    RESPONDER,
    manager:      MANAGER,
    system_admin: SYSTEM_ADMIN
  }.freeze

  TeamAccessLevelsByValue = TeamAccessLevels.invert.freeze

  OrganizationAccessLevels = {
    member:       MEMBER,
    system_admin: SYSTEM_ADMIN
  }

  OrganizationAccessLevelsByValue = OrganizationAccessLevels.invert.freeze

  AccessLevelsByValue = {}
    .merge(TeamAccessLevelsByValue)
    .merge(OrganizationAccessLevelsByValue)
    .freeze

  belongs_to :user
  belongs_to :team

  belongs_to :created_by, class_name: "User", optional: true

  validates :access_level, presence: true
  validates :user, uniqueness: { scope: :team }
  validate :user_in_organization
  # validates :access_level, inclusion: { in: TeamAccessLevels.values }
  # validates :access_level, inclusion: { in: OrganizationAccessLevels.values }

  before_destroy { throw :abort if user_not_used_in_teams }
  validate :user_not_used_in_teams, on: :destroy

  attribute :access_level, default: 0

  delegate :name, to: :user, prefix: true

  def access_level_symbol
    AccessLevelsByValue[access_level]
  end

  private

  def user_in_organization
    return unless team&.parent
    errors.add(:user, 'is not member of organization') unless user&.organization_users&.include?(user)
  end

  def user_not_used_in_teams
    return unless Organization === team
    unless !Member.where(team_id: team.descendants, user_id: user).exists?
      errors.add(:user, 'is part of Teams in Organization')
      throw :abort
    end
  end
end
