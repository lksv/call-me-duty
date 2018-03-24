# == Schema Information
#
# Table name: integrations
#
#  id         :integer          not null, primary key
#  name       :string           default(""), not null
#  key        :string
#  type       :string
#  service_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_integrations_on_key         (key)
#  index_integrations_on_name        (name) UNIQUE
#  index_integrations_on_service_id  (service_id)
#

class Integration < ApplicationRecord
  Integration.inheritance_column = nil

  enum type: {prometheus: 1}

  belongs_to :service
  has_many   :incidents

  has_secure_token :key

  validates :key, uniqueness: true
  validates :type, presence: true, allow_nil: false

  delegate :team, to: :service

  strip_attributes only: :name, collapse_spaces: true, replace_newlines: true
end
