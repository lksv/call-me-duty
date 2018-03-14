class BaseNotificationService
  attr_reader :user, :event_type, :target, :source

  # event_types: [:incident_created, :incident_changed, :on_call_started, :on_call_finished]
  # target: [
  #   incident_instance, - in case of :incident_created and incident_changed
  #   calendar_event_instance - in case of on_call_started on_call_finished
  # ],
  # source - nepovinnny zdorj odkud to prislo (konkretni policy_rule)
  def initialize(user, event_type:, target:, source: nil)
    @user = user
    @event_type = event_type
    @target = target
    @source = source
  end

  def create_delivery_record
    Message.create(
      user: user,
      delivery_type: :email,
      delivery_address: user.email,
      source: source,
      subject: subject,  # only for email
      message: message_body,
    )
  end

  def subject
    nil #it is used only by EmailNotificationService
  end

  def messge_body
    raise 'Needs to be implemented in sub-class!'
  end

  def calculate_delivery_delay
    # when zero message send in last minute
    if last_delivery(in: 1.minute, under: 0)
      #deliver!
    # when less then 3 messages send in last two minutes
    elsif last_delivery(in: 2.minute, under: 3)
      #deliver
    elsif last_delivery(in: 5.minute, under: 6)
    else
      schdule_later!
    end
  end
end

