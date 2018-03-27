# == Schema Information
#
# Table name: escalation_policies
#
#  id              :integer          not null, primary key
#  name            :string           default(""), not null
#  description     :text
#  team_id         :integer
#  clonned_from_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_escalation_policies_on_clonned_from_id  (clonned_from_id)
#  index_escalation_policies_on_name             (name)
#  index_escalation_policies_on_team_id          (team_id)
#

class EscalationPolicy < ApplicationRecord
  belongs_to :team
  has_many :escalation_rules,
           -> { order(delay: :asc) },
           dependent: :destroy,
           inverse_of: :escalation_policy
  has_many :incidents
  has_many :targetable_escalation_rules, class_name: 'EscalationRule', as: :targetable



  # `#clonned_from` means it is a backup item created in `created_at` time.
  # When EscalationPolicy is executed, it is created a backup of current state
  # of whole EscalationPolicy (and its EscalationRules) and this backup is used
  # in all backgroud jobs (e.g. all escalation rules action are executed on this
  # backup).
  #
  # Use `.prime` to filter out all backups
  belongs_to :clonned_from,
            class_name: 'EscalationPolicy',
            optional: true,
            inverse_of: :clones
  has_many :clones,
           foreign_key: :clonned_from_id,
           class_name: 'EscalationPolicy',
           inverse_of: :clonned_from


  validates :name, presence: true, allow_nil: false
  validate :name_uniqueness_for_not_cloned

  accepts_nested_attributes_for :escalation_rules,
    reject_if: :all_blank,
    allow_destroy: true

  strip_attributes only: :name, collapse_spaces: true, replace_newlines: true

  scope :prime, -> { where(clonned_from: nil) }

  def readonly?
    !new_record? && clonned_from_id && !team.marked_for_destruction
  end

  def find_or_build_clone
    last_clone = clones.reorder(created_at: :asc).limit(1).first
    return build_clone unless last_clone

    # if there was a changes after created of last_clone then build a new one
    (last_clone.created_at > self.updated_at) ? last_clone : build_clone
  end

  private

  # create a deep copy, e.g. copy all escalation_rules
  #
  def build_clone
    new_clone = self.dup
    new_clone.clonned_from = self
    new_clone.id = nil

    escalation_rules.each do |escalation_rule|
      er_attrs = escalation_rule.attributes
      er_attrs.delete 'id'
      new_clone.escalation_rules.build er_attrs
    end
    new_clone
  end

  private

  def name_uniqueness_for_not_cloned
    return if clonned_from

    uniq_condition = EscalationPolicy.where(name: name)
    uniq_condition = uniq_condition.where.not(id: id) if id
    errors.add(:name, 'has already been taken') unless uniq_condition.size == 0
  end
end
