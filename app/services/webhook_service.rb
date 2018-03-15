class WebhookService
  include HTTParty

  EVENT2VAR_NAME = {
    incident_created:     'incident',
    incident_acked:       'incident',
    incident_resolved:    'incident',
    on_call_started:      'calendar_event',
    on_call_finished:     'calendar_event'
  }

  default_timeout Settings.webhook_timeout

  attr_reader :message, :webhook_gateway, :event

  def initialize(mesasge)
    @message = message
    @event = message.event
    @delivery_gateway = message.delivery_gateway
  end

  def messageable
    message.messageable
  end

  def execute
    self.class.post(
      @delivery_gateway.uri,
      body: build_body(@delivery_gateway.template),
      headers: build_headers(@delivery_gateway.headers),
      verify: @delivery_gateway.verify || true
    )
  # HTTParty::Error inherites from StandardError
  rescue HTTParty::Error, StandardError => err
    Rails.logger.error("Webhook http error: %s, message: %s, gateway: %s" % [
      err.to_s, message.inspect, delivery_gateway.inspect
    ])
    message.status = :failed
    message.save!
  end

  private

  def build_body(template)
    vars = {
      event: event,
      EVENT2VAR_NAME[event] => messageable
    }
    template.gsub(/{{\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*}}/) do
      variable = $1
      escaped = variable.sub!(/_escaped\z/, '')
      value = vars[variable.intern].to_s
      escaped ?  value.inspect : value
    end
  end

  def build_headers(headers)
    { 'Content-Type' => 'application/json' }.merge(headers || {})
  end
end
