# == Schema Information
#
# Table name: escalation_rules
#
#  id                   :integer          not null, primary key
#  escalation_policy_id :integer
#  condition_type       :integer          not null
#  action_type          :integer          not null
#  delay                :integer
#  target_type          :string
#  target_id            :integer
#  finished_at          :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_escalation_rules_on_escalation_policy_id       (escalation_policy_id)
#  index_escalation_rules_on_target_type_and_target_id  (target_type,target_id)
#

# EscalationRule consists of three main parts:
# * `#delay` (in second) whed this EventRule should be executed
# * `#condition`, the condition which will be evaluated when the EscalationRule
#    is executed
# * `#action`, the action which will be executed in case of successful condition
class EscalationRule < ApplicationRecord
  enum condition_type:  [:true, :not_acked, :not_resolved]
  enum action_type:     [:user, :team, :webhook, :close_incident, :reset_incident]

  belongs_to :escalation_policy,    inverse_of: :escalation_rules, touch: true
  belongs_to :target, polymorphic: true, optional: true

  validates :delay, presence: true


  delegate :incident, to: :escalation_policy

  def condition
    "EscalationRule::#{condition_type.camelize}Condition"
      .safe_constantize
      .new(incident)
  end

  def action
    "EscalationRule::#{action_type.camelize}Action"
      .safe_constantize
      .new(target, incident)
  end
end
