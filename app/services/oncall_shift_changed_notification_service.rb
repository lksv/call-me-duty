class OncallShiftChangedNotificationService
  attr_reader :prev_calendar_event, :new_calendar_event

  def initialize(prev_calendar_event, new_calendar_event)
    @prev_calendar_event = prev_calendar_event
    @new_calendar_event = new_calendar_event
  end

  def execute
    if prev_calendar_event && new_calendar_event &&
       (prev_calendar_event.calendar != new_calendar_event.calendar)
      # TODO - validation error
    end

    # TODO
    # ...send mail or SMS
  end
end
