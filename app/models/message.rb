# == Schema Information
#
# Table name: messages
#
#  id                  :integer          not null, primary key
#  status              :integer          not null
#  event               :integer          not null
#  messageable_type    :string
#  messageable_id      :integer
#  static_gateway      :string
#  delivery_gateway_id :integer
#  user_id             :integer
#  delivered_at        :datetime
#  gateway_request_uid :string
#  answered_at         :datetime
#  ended_at            :datetime
#  cost                :float
#  duration            :integer
#  error_msg           :text(1024)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_messages_on_delivery_gateway_id                  (delivery_gateway_id)
#  index_messages_on_event                                (event)
#  index_messages_on_messageable_type_and_messageable_id  (messageable_type,messageable_id)
#  index_messages_on_user_id                              (user_id)
#

# Keeps info about message/notification
# Fields `cost`, `ended_at`, `answered_at` and `gateway_request_uid` are
# fullfilled only for particular gateways type, e.g  VoiceCall and SMS (which
# are delivered by external service).
#
class Message < ApplicationRecord
  STATIC_GATEWAYS = [
    'VoiceCallMessagebirdGateway',
    'EmailGateway'
  ]

  enum status: %i(created delivering delivered delivery_fail)
  enum event: %i(
                  incident_created incident_acked incident_resolved
                  on_call_started on_call_finished
                )

  # TODO: for now, there are some delivery gateways hardcoded.
  # e.g. CallUserIncidentNotificationService hardcodes call through MessageBird
  # service. It could be chnaged in future versions. Then `optional: true` needs
  # to be removed.
  # ..or `predefined_gateway: String` should be created.
  belongs_to :delivery_gateway, optional: true

  # `user` is set only for personal delivery e.g. email, voice, sms
  belongs_to :user, optional: true

  # could be incident or calendar_event
  belongs_to :messageable, polymorphic: true

  validate :delivery_gateway_xor_static_gateway_validation

  validates :static_gateway,
    presence: true, inclusion: { in: STATIC_GATEWAYS }, allow_nil: true
  validates :user, presence: true, if: -> () { delivery_gateway&.personal? }

  # It returns custom delivery gateway or static one
  def delivery_gateway
    super ||
      static_gateway && "::StaticGateway::#{static_gateway}".safe_constantize&.new
  end

  private

  def delivery_gateway_xor_static_gateway_validation
    if (ActiveRecord::Base === delivery_gateway) && static_gateway
      errors.add(:base, 'delivery_gateway and static_gateway cannot be set together!')
      return false
    end

    if delivery_gateway.nil? && static_gateway.nil?
      errors.add(:base, 'delivery_gateway or static_gateway has to be set')
      return false
    end
  end
end
