# Make a outboud call to users phone number.
# It also records this call in Message object.
#
# Currentyl it is hardcoded to use external MessageBird service.
# It will probably chnage in future versions to split the code to internal
# general API and wrappers for particular call prodviders (MessageBird, Nexmo,
# ...)

class VoiceCallIncidentNotificationService
  include HTTParty

  MESSAGEBIRD_GATEWAY = {
    url: 'https://voice.messagebird.com/calls',
    timeout: Settings.messagebird.call_timeout,
    headers: {
      'Authorization' => "AccessKey #{Settings.messagebird.access_key}"
    },
    payload: {
      source: "#{Settings.messagebird.source}",
      destination: nil,
      callFlow: {
        title: "New Incident",
        steps: [{
          action: "say",
          options: {
            "payload": "Hi, this is Call Me Pager. There is new incident!",
            "voice": "male",
            "language": "en-US"
          }
        }]
      }
    }
  }.freeze

  default_timeout MESSAGEBIRD_GATEWAY[:timeout]

  attr_reader :incident, :user, :source

  def initialize(incident:, user:, source:)
    @incident = incident
    @user = user
    @source = source
  end

  def phone
    user.phone
  end

  def execute
    if user.nil?
      # TODO IncidentAuditService
      return
    end
    message = Message.create!(
      status: 'created',
      event: 'incident_created',
      user: user,
      messageable: incident,
      static_gateway: 'VoiceCallMessagebirdGateway'
    )

    begin
      response = self.class.post(
        MESSAGEBIRD_GATEWAY[:url],
        body: build_payload,
        headers: build_headers,
        verify: true
      )

      if response.success? && (call_uid = response_call_uid(response))
        message.status = :delivering
        message.gateway_request_uid = call_uid
      else
        message.status = :delivery_fail
        message.error_msg = response.to_s[0..1023]
      end
      message.save!

    # HTTParty::Error inherites from StandardError
    rescue HTTParty::Error, StandardError => err
      Rails.logger.error("VoiceCallIncidentNotificationService error: %s, message: %s" % [
        err.to_s, message.inspect
      ])
      message.status = :delivery_fail
      message.error_msg = err.to_s[0..1023]
      message.save!
    end
  end

  private

  def response_call_uid(response)
    return nil unless response.success?
    response.fetch('data')&.first&.fetch('id')
  end

  def build_headers
    MESSAGEBIRD_GATEWAY[:headers]
  end

  def build_payload
    payload = MESSAGEBIRD_GATEWAY[:payload]
    payload[:destination] = user.phone
    payload.to_json
  end
end
