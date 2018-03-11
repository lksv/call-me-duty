# == Schema Information
#
# Table name: services
#
#  id          :integer          not null, primary key
#  name        :string           default(""), not null
#  description :text
#  team_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_services_on_name     (name) UNIQUE
#  index_services_on_team_id  (team_id)
#

# TODO add migration:
# * auto_resolve_after:Integer \
# * cancel_acknowledgement_after:Integer

class Service < ApplicationRecord
  belongs_to :team
  has_many :integrations,    dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :team }

  strip_attributes only: :name, collapse_spaces: true, replace_newlines: true
end
