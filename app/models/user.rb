# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  email                   :string           default(""), not null
#  encrypted_password      :string           default(""), not null
#  reset_password_token    :string
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0), not null
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :string
#  last_sign_in_ip         :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  phone                   :string
#  name                    :string
#  default_organization_id :integer
#
# Indexes
#
#  index_users_on_default_organization_id  (default_organization_id)
#  index_users_on_email                    (email) UNIQUE
#  index_users_on_reset_password_token     (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :async, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :calendar_events,        inverse_of: :user
  has_many :escalation_rules,       as: :targetable

  has_many :members
  has_many :teams, through: :members
  has_many :organizations, -> { where(parent_id: nil, teams: { type: 'Organization'}) }, through: :members, source: 'team'
  has_many :organization_users, through: :organizations, source: 'users'

  belongs_to :default_organization, class_name: 'Organization', optional: true

  validate :set_default_organization,       on: :update

  # has_and_belongs_to_many :teams

  def services
    Service.where(team_id: teams)
  end

  def visible_users
    organization_users.distinct
  end

  # All teams where the user is member of and all that teams descendants
  # We need to return also all descendants teams
  #
  # Do not pass Organization to Team#visible_teams it would return all
  # organization's teams
  def visible_teams
    teams.where(type: nil).visible_teams
  end

  private

  def set_default_organization
    self.default_organization = organizations.first if default_organization.nil?
  end
end
