# == Schema Information
#
# Table name: incidents
#
#  id                   :integer          not null, primary key
#  iid                  :integer          not null
#  status               :integer          default("created")
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
#  index_incidents_on_team_id_and_iid       (team_id,iid) UNIQUE
#

class Incident < ApplicationRecord
  enum status:     { created: 0, triggred: 1, acked: 2, snoozed: 3, resolved: 10 }
  enum priority:   { critical: 0, warn: 5, info: 10 }

  # notifications of :incident_created, :incident_acked and :incident_resolved
  has_many :messages,  as: :messageable

  belongs_to :team
  belongs_to :integration,          optional: true
  belongs_to :service,              optional: true
  belongs_to :escalation_policy,    optional: true

  validates :title, presence: true

  before_validation :set_service_when_integration

  validate :integration_belongs_to_service
  validate :set_iid,                on: :create
  validates :iid,                   presence: true, numericality: true
  validates :iid,                   uniqueness: { scope: :team }

  delegate :name, to: :service, prefix: true, allow_nil: true
  delegate :name, to: :team, prefix: true, allow_nil: true
  delegate :name, to: :integration, prefix: true, allow_nil: true
  delegate :name, to: :escalation_policy, prefix: true, allow_nil: true

  def readonly?
    !new_record? && resolved? && !team.marked_for_destruction
  end

  def to_param
    iid.to_s
  end

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

  def set_iid
    return if iid.present? or team.nil?
    self.iid = team.incidents.maximum(:iid).to_i + 1
  end
end
