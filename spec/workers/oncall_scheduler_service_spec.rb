require 'rails_helper'

RSpec.describe OncallSchedulerService do
  describe '#perform' do

  end

  describe '#schedule_calendar' do
    let(:calendar) { create(:calendar) }
    let(:event2017) { event(calendar, '2017-01-01 00:00:00', '2018-01-01 00:00:00') }
    let(:event2018) { event(calendar, '2018-01-01 00:00:00', '2019-01-01 00:00:00') }
    let(:event2019) { event(calendar, '2019-01-01 00:00:00', '2020-01-01 00:00:00') }

    it 'calls calendar.calculate_current_calendar_event' do
      expect(calendar).to receive(:calculate_current_calendar_event).and_return(nil)
      subject.schedule_calendar(
        calendar: calendar,
        at: Time.new(2017,1,1),
        least_change_at: Time.new(2017,1,1)
      )
    end

    it 'saves current calendar.current_calendar_event when current_calendar_event changed' do
      event2017

      subject.schedule_calendar(
        calendar: calendar,
        at: event2017.start_at,
        least_change_at: Time.new(2017,1,1)
      )
      calendar.reload
      expect(calendar.current_calendar_event).to eq event2017
    end

    it 'returns next_change_at when it\'s earlier then least_change_at' do
      event2017

      least_change_at = Time.new(2030, 1, 1)
      res = subject.schedule_calendar(
        calendar: calendar,
        at: event2017.start_at,
        least_change_at: least_change_at
      )
      expect(res).to eq event2017.end_at
    end

    it 'returns least_change_at when it\'s earlier then next_change_at' do
      event2017

      least_change_at = Time.new(2017, 2, 2)
      res = subject.schedule_calendar(
        calendar: calendar,
        at: event2017.start_at,
        least_change_at: least_change_at
      )
      expect(res).to eq least_change_at
    end

    context 'when current_calendar_event is not going to change' do
      it 'do not call OncallSchedulerService' do
        calendar.current_calendar_event = event2017
        calendar.save!

        expect_any_instance_of(OncallShiftChangedNotificationService).to_not receive(:execute)
        subject.schedule_calendar(
          calendar: calendar,
          at: event2017.start_at,
          least_change_at: Time.new(2017,1,1)
        )
      end
    end
    context 'when current_calendar_event change to new event of the same user' do
      it 'do not call OncallSchedulerService' do
        calendar.current_calendar_event = event2017
        calendar.save!

        expect_any_instance_of(OncallShiftChangedNotificationService).to_not receive(:execute)
        subject.schedule_calendar(
          calendar: calendar,
          at: event2017.start_at,
          least_change_at: Time.new(2017,1,1)
        )
      end
    end

    it 'do not call OncallSchedulerService when event chagne but user stay same' do
      calendar.current_calendar_event = event2017
      calendar.save!
      event2018

      expect_any_instance_of(OncallShiftChangedNotificationService).to_not receive(:execute)
      subject.schedule_calendar(
        calendar: calendar,
        at: event2018.start_at,
        least_change_at: Time.new(2017,1,1)
      )
    end

    it 'calls OncallShiftChangedNotificationService when user on call is changed' do
      calendar.current_calendar_event = event2017
      calendar.save!
      user = create(:user, teams: [ event2017.calendar.team ])
      event2018.user = user
      calendar.reload
      event2018.save!

      expect_any_instance_of(OncallShiftChangedNotificationService).to receive(:execute)
      subject.schedule_calendar(
        calendar: calendar,
        at: event2018.start_at,
        least_change_at: Time.new(2017,1,1)
      )
    end
  end
end
