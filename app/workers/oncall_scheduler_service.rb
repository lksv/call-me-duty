class OncallSchedulerService
  include Sidekiq::Worker
  sidekiq_options :queue => :oncall_scheduler, :retry => 2, :backtrace => true

  sidekiq_retry_in do |count|
    10 * (count + 1) # (i.e. 10, 20, 30, 40, 50)
  end

  def perform(at: DateTime.now)
    least_change_at = Time.now + 30.minutes
    Teams.includes(calendar: :calendar_event).find_each do |team|
      calendar = team.calendar
      next unless calendar

      least_change_at = schedule_calendar(
        calendar: calendar,
        at: at,
        least_change_at: least_change_at
      )
    end
  ensure
    self.class.perform_at(least_change_at + 3.second)
  end

  def schedule_calendar(calendar:, at:, least_change_at:)
    prev_calendar_event = calendar.current_calendar_event

    calendar.calculate_current_calendar_event(at: at)

    # needs to update least_change_at
    unless calendar.changed?
      return calendar.current_calendar_event&.end_at || least_change_at
    end

    calendar.save!

    nce = calendar.next_change_at(at: at)
    least_change_at = nce if nce && nce < least_change_at

    if prev_calendar_event&.user != calendar&.current_oncall_user
      OncallShiftChangedNotificationService.new(
        prev_calendar_event,
        calendar.current_calendar_event
      ).execute
    end
    least_change_at
  end
end
