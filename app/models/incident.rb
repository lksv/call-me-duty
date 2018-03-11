# == Schema Information
#
# Table name: incidents
#
#  id                   :integer          not null, primary key
#  status               :integer
#  title                :string(127)
#  description          :text
#  data                 :text
#  team_id              :integer
#  integration_id       :integer
#  service_id           :integer
#  escalation_policy_id :integer
#  priority             :integer
#  alert_trigged_count  :integer
#  snoozed_until        :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_incidents_on_escalation_policy_id  (escalation_policy_id)
#  index_incidents_on_integration_id        (integration_id)
#  index_incidents_on_service_id            (service_id)
#  index_incidents_on_team_id               (team_id)
#

class Incident < ApplicationRecord
  enum status:     [:created, :triggred, :acked, :snoozed, :resolved]
  enum priority:   [:critical, :warn, :info]

  belongs_to :team
  belongs_to :integration,          optional: true
  belongs_to :service,              optional: true
  belongs_to :escalation_policy,    optional: true

  validates :title, presence: true

  before_validation :set_service_when_integration

  validate :integration_belongs_to_service


  private

  def set_service_when_integration
    return if service or integration.nil?
    self.service = integration.service
  end

  def integration_belongs_to_service
    return true if service.nil? or integration.nil?

    unless integration.service == service
      errors.add(:integration, "Integratin has to belong to the same service")
    end
  end
end
