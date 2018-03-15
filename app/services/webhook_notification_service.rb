class WebhookNotificationService
  include HTTParty

  default_timeout Settings.webhook_timeout

  attr_reader :incident, :source, :gateway

  def initialize(incident:, source:, gateway:)
    @incident = incident
    @source = source
    @gateway = gateway
  end

  def execute
    message = Message.create!(
			status: 'created',
		  event: 'incident_created',
      messageable: incident,
      delivery_gateway: gateway
    )

    begin
      method = gateway.http_method.downcase.intern
      payload = build_payload(
        gateway.template,
        incident
          .attributes
          .merge(event: :incident_created)
          .with_indifferent_access
      )
      response = self.class.send(
        method,
        gateway.uri,
        body: payload,
        headers: build_headers(gateway.headers),
        verify: true
      )

      if response.success?
        message.status = :delivered
        message.delivered_at = Time.now
      else
        message.status = :delivery_fail
        message.error_msg = response.to_s[0..1023]
      end
      message.save!

    #HTTParty::Error inherites from StandardError
    rescue HTTParty::Error, StandardError => err
      Rails.logger.error("WebhookNotificationService error: %s, message: %s" % [
        err.to_s, message.inspect
      ])
      message.status = :delivery_fail
      message.error_msg = err.to_s[0..1023]
      message.save!
    end
  end


  private

  def build_payload(template, vars)
    template.gsub(/{{\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*(\|\s*toJson\s*)?}}/) do
      variable = $1
      toJson = $2
      value = vars[variable.intern].to_s
      toJson ?  value.to_json : value
    end
  end

  def build_headers(headers)
    { 'Content-Type' => 'application/json' }.merge(headers || {})
  end
end
