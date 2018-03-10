module CalendarEventHelpers
  def event(calendar, start_at, end_at)
    calendar.calendar_events.create!(
      user:     calendar.team.users.first,
      start_at: start_at,
      end_at:   end_at
    )
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include CalendarEventHelpers
end
