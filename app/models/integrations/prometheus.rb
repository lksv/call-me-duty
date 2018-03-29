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

class Prometheus < Integration
  validates :type, inclusion: { in: %w(Prometheus) }
end
