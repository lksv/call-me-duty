# == Schema Information
#
# Table name: teams
#
#  id               :integer          not null, primary key
#  name             :string           default(""), not null
#  type             :string
#  description      :text
#  parent_id        :integer
#  owner_id         :integer
#  slug             :string           default(""), not null
#  full_path        :string           default(""), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  visibility_level :integer          default(0), not null
#
# Indexes
#
#  index_teams_on_full_path           (full_path) UNIQUE
#  index_teams_on_owner_id            (owner_id)
#  index_teams_on_parent_id           (parent_id)
#  index_teams_on_parent_id_and_name  (parent_id,name) UNIQUE
#  index_teams_on_parent_id_and_slug  (parent_id,slug) UNIQUE
#  index_teams_on_type                (type)
#

class Team < ApplicationRecord
  PRIVATE   = 0
  INTERNAL  = 10
  PUBLIC    = 20

  VisibilityLevels = {
    private:  PRIVATE,
    internal: INTERNAL,
    public:   PUBLIC
  }.freeze

  VisibilityLevelsByValue = VisibilityLevels.invert.freeze

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
  validates :visibility_level,
    presence: true,
    allow_nil: false,
    inclusion: { in: VisibilityLevels.values }

  after_create :set_calendar

  strip_attributes only: :name, collapse_spaces: true, replace_newlines: true

  delegate :current_oncall_user, to: :calendar, allow_nil: true

  # it must be set, before team.destroy
  attr_accessor :marked_for_destruction

  def self.visible_teams
    objects = self.distinct.pluck(:id, :full_path)
    paths = objects.map(&:last)
    ids = objects.map(&:first)

    teams = Team.arel_table
    arel_false_condition = Arel::Nodes::SqlLiteral.new('1').eq(0)
    query = paths.reduce(arel_false_condition) do |memo, obj|
      memo.or(teams[:full_path].matches("#{obj}/%"))
    end
    query = query.or(arel_table[:id].in(ids))

    Team.unscoped.where(query)
  end

  ###

  def visibility_level_symbol
    VisibilityLevelsByValue[visibility_level]
  end

  # def oncall_at(at: DateTime.now)
  #   calendar&.oncall_at(at: at)
  # end

  # When it is root team, it's an `Organization`
  #
  def organization?
    parent_id.nil?
  end

  def public?
    visibility_level == PUBLIC
  end

  def internal?
    visibility_level == INTERNAL
  end

  def private?
    visibility_level == PRIVATE
  end

  def visible_for_user?(user)
    !!(public? ||
        (user && internal? && organization.users.include?(user)) ||
        user&.visible_teams&.include?(self)
      )
  end

  def access_level_for_user(user)
    level = members.find_by(user: user)&.access_level
    return level if level

    parent.access_level_for_user(user)
  end

  def slugs
    @slugs ||= full_path.split('/')
  end

  def organization
    return self unless parent

    return parent if slugs.size == 1
    Organization.find_by(slug: slugs.first)
  end

  def ancestor_paths
    slugs
      .map.with_index { |obj,idx| slugs[0, idx + 1] }
      .map { |t| t.join('/') }
  end

  def ancestors
    Team.where(full_path: ancestor_paths)
  end

  def descendants
    teams = Team.arel_table
    Team.where(teams[:full_path].matches("#{full_path}/%"))
  end

  def visible_delivery_gateways
    DeliveryGateway.where(team_id: ancestors)
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
