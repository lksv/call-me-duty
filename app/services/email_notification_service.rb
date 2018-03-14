class  EmailNotificationService < BaseNotificationService
  def execute
    create_delivery_record
    schedule_message(message)
  end

  private

  def subject
    render_to_string("#{event_type}_subject", incident: target)
  end

  def message_body
    render_to_string("#{event_type}_body", incident: target)
  end
end
