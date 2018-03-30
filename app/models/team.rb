# == Schema Information
#
# Table name: teams
#
#  id          :integer          not null, primary key
#  name        :string           default(""), not null
#  description :text
#  parent_id   :integer
#  owner_id    :integer
#  slug        :string           default(""), not null
#  full_path   :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_teams_on_full_path           (full_path) UNIQUE
#  index_teams_on_owner_id            (owner_id)
#  index_teams_on_parent_id           (parent_id)
#  index_teams_on_parent_id_and_name  (parent_id,name) UNIQUE
#  index_teams_on_parent_id_and_slug  (parent_id,slug) UNIQUE
#

class Team < ApplicationRecord
  before_destroy { |record| record.marked_for_destruction = true }

  # has_and_belongs_to_many :users
  has_many :services,             dependent: :destroy
  has_many :escalation_policies,  dependent: :destroy
  #has_many :webhooks,             dependent: :destroy
  has_many :incidents,            dependent: :destroy
  has_many :delivery_gateways,    dependent: :destroy
  has_many :webhook_gateways
  has_many :escalation_rules,     as: :targetable
  has_one  :calendar,              dependent: :destroy

  has_many   :children, class_name: "Team", foreign_key: :parent_id
  belongs_to :parent, class_name: "Team", optional: true

  has_many :members, dependent: :destroy
  has_many :users, through: :members

  validate  :set_slug,            on: :create
  validate  :set_full_path,       on: :create
  validates :full_path,           uniqueness: true
  validates :slug, presence: true, uniqueness: { scope: :parent }
  validates :name, presence: true, uniqueness: { scope: :parent }

  after_create :set_calendar

  strip_attributes only: :name, collapse_spaces: true, replace_newlines: true

  delegate :current_oncall_user, to: :calendar, allow_nil: true

  # it must be set, before team.destroy
  attr_accessor :marked_for_destruction

  # def oncall_at(at: DateTime.now)
  #   calendar&.oncall_at(at: at)
  # end

  # When it is root team, it's an `Organization`
  #
  def organization?
    parent_id.nil?
  end

  def to_param
    full_path
  end

  private

  def set_slug
    return slug if slug.present?
    self.slug = name.to_s.parameterize
  end

  def set_full_path
    return full_path if full_path.present?
    self.full_path = organization? ? slug : parent.full_path + '/' + slug
  end

  def set_calendar
    self.create_calendar!
  end
end
