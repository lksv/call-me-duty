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
  has_and_belongs_to_many :users
  has_many :services,             dependent: :destroy
  has_many :escalation_policies,  dependent: :destroy
  has_many :webhooks,             dependent: :destroy
  has_many :incidents,            dependent: :destroy
  has_one :calendar,              dependent: :destroy

  validates :name, presence: true, uniqueness: true

  strip_attributes only: :name, collapse_spaces: true, replace_newlines: true

  def on_call
    # TODO
    escalation_policies&.first&.on_call
  end
end
