# == Schema Information
#
# Table name: escalation_rules
#
#  id                   :integer          not null, primary key
#  escalation_policy_id :integer
#  condition_type       :integer          not null
#  action_type          :integer          not null
#  delay                :integer
#  targetable_type      :string
#  targetable_id        :integer
#  finished_at          :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_escalation_rules_on_escalation_policy_id               (escalation_policy_id)
#  index_escalation_rules_on_targetable_type_and_targetable_id  (targetable_type,targetable_id)
#

# EscalationRule consists of three main parts:
# * `#delay` (in second) whed this EventRule should be executed
# * `#condition`, the condition which will be evaluated when the EscalationRule
#    is executed
# * `#action`, the action which will be executed in case of successful condition
class EscalationRule < ApplicationRecord
  enum condition_type:  [:true, :not_acked, :not_resolved]
  enum action_type:     [
    :on_call_email, :on_call_voice_call,
    :user_email, :user_voice_call,
    :webhook,
    :close_incident, # reset_escalation_policy
  ]

  belongs_to :escalation_policy,    inverse_of: :escalation_rules, touch: true

  # the target of notification. Could be: User, EscalationPolicy, Webhook
  belongs_to :targetable, polymorphic: true, optional: true

  validates :delay, presence: true, numericality: true

  def readonly?
    !new_record? && escalation_policy.readonly?
  end

  def condition(incident)
    "EscalationRule::#{condition_type.camelize}Condition"
      .safe_constantize
      .new(incident)
  end

  def action(incident)
    "EscalationRule::#{action_type.camelize}Action"
      .safe_constantize
      .new(targetable, incident, self)
  end
end
