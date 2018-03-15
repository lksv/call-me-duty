class EmailIncidentNotificationService
  attr_reader :incident, :user, :source

  def initialize(incident:, user:, source:)
    @incident = incident
    @user = user
    @source = source
  end

  def email
    user.email
  end

  def execute
    if user.nil?
      # IncidentAuditService...
      return
    end
    message = Message.create!(
      status: 'created',
      event: 'incident_created',
      user: user,
      messageable: incident,
      static_gateway: 'EmailGateway'
    )

    begin
      UserMailer.incident_created(
        user: message.user,
        incident: incident
      ).deliver_now

      message.status = 'delivered'
      message.delivered_at = Time.now
      message.save!

    rescue StandardError => err
      Rails.logger.error("VoiceCallIncidentNotificationService error: %s, message: %s" % [
        err.to_s, message.inspect
      ])
      message.status = :delivery_fail
      message.error_msg = err.to_s[0..1023]
      message.save!
    end
  end
end
