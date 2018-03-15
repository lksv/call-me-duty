# == Schema Information
#
# Table name: teams
#
#  id          :integer          not null, primary key
#  name        :string           default(""), not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_teams_on_name  (name) UNIQUE
#

class Team < ApplicationRecord
  before_destroy { |record| record.marked_for_destruction = true }

  has_and_belongs_to_many :users
  has_many :services,             dependent: :destroy
  has_many :escalation_policies,  dependent: :destroy
  #has_many :webhooks,             dependent: :destroy
  has_many :incidents,            dependent: :destroy
  has_many :delivery_gateways,    dependent: :destroy
  has_many :escalation_rules,     as: :targetable
  has_one :calendar,              dependent: :destroy

  validates :name, presence: true, uniqueness: true

  after_create :set_calendar

  strip_attributes only: :name, collapse_spaces: true, replace_newlines: true

  delegate :current_oncall_user, to: :calendar, allow_nil: true

  # it must be set, before team.destroy
  attr_accessor :marked_for_destruction

  # def oncall_at(at: DateTime.now)
  #   calendar&.oncall_at(at: at)
  # end

  private

  def set_calendar
    self.create_calendar!
  end
end
