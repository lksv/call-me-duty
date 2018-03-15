# == Schema Information
#
# Table name: delivery_gateways
#
#  id         :integer          not null, primary key
#  name       :string
#  type       :string
#  team_id    :integer
#  data       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_delivery_gateways_on_team_id  (team_id)
#  index_delivery_gateways_on_type     (type)
#

# There are different kinds of DeliveryGateway
# 1. predefined vs custom
#    * static: EmailGateway, VoiceGateway, SmsGateway - there cannot be more the one instance
#    * dynamic: WebhookGateway, SlackGateway
#    where static do not need `name` attribute whiel `dynamic` needs it.
#    E.g. you usually do not need to define your own outgoing SMTP server.
#    Or, VoiceGateway could be custom, if you provide ability to define
#    provider and the yourself api key to use.
#    E.g. predefined are created immediately after the team was created?
# 2. by reccipient
#    * personal: EmailGateway, VoiceGateway, SmsGateway, PhoneGateway
#    * group: WebhookGateway, SlackGateway
#    where `personal` needs to pass `user` record to #notify method while
#    group do not.
class DeliveryGateway < ApplicationRecord
  GATEWAYS = %w(WebhookGateway)

  enum status: [:created, :failed, :delivered]

  store :data, accessors: [], coder: JSON
  belongs_to :team
  has_many   :escalation_rules,     as: :targetable

  validates :name, presence: true, uniqueness: { scope: :team }
  validates :type, presence: true, inclusion: { in: GATEWAYS }

  strip_attributes only: :name, collapse_spaces: true, replace_newlines: true

  def personal?
    raise 'Needs to be implemented in subclass!'
  end
end
