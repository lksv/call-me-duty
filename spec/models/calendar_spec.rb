require 'rails_helper'

RSpec.describe Calendar, type: :model do

  let(:calendar)      { create(:calendar) }
  let(:event2017) { event(calendar, '2017-01-01 00:00:00', '2018-01-01 00:00:00') }
  let(:event2018) { event(calendar, '2018-01-01 00:00:00', '2019-01-01 00:00:00') }
  let(:event2019) { event(calendar, '2019-01-01 00:00:00', '2020-01-01 00:00:00') }


  describe 'FactoryBot.create(:calendar)' do
    subject { create(:calendar) }
    it 'create Calendar' do
      expect(subject.valid?).to be true
      expect(subject.team.calendar).to be subject
    end
  end

  describe 'validates current_calendar_event_belongs_to_this_calendar' do
    it 'pass validation when current_calendar_event is not set' do
      subject = Calendar.new
      subject.valid?
      expect(subject.errors[:current_calendar_event].size).to be 0
    end

    it 'pass validation when current_calendar_event belongs to this calendar' do
      calendar.current_calendar_event = event2017
      calendar.valid?
      expect(calendar.errors[:current_calendar_event].size).to be 0
    end

    it 'fails validating when current_calendar_event belongs_to another calendar' do
      calendar.current_calendar_event = create(:calendar_event)
      calendar.valid?
      expect(calendar.errors[:current_calendar_event].size).to be 1
    end
  end

  describe '#calculate_current_calendar_event' do
    it 'keeps current_calendar_event if current time is in range' do
      calendar.current_calendar_event = event2017
      calendar.save!

      expect(calendar).to_not receive(:event_at)
      calendar.calculate_current_calendar_event(at: event2017.start_at)
      expect(calendar.changed?).to be false
    end

    it 'calls sets current_calendar_event by #event_at when ' \
       'current_calendar_event is not in current time range' do
      event2018
      calendar.current_calendar_event = event2017
      calendar.save!

      expect(calendar).to receive(:event_at).and_call_original
      calendar.calculate_current_calendar_event(at: event2018.start_at)
      expect(calendar.current_calendar_event).to eq event2018
    end

    it 'sets current_calendar_event to nil when no calendar_event exist in ' \
       'current time range' do
      event2019
      calendar.current_calendar_event = event2017
      calendar.save!
      calendar.calculate_current_calendar_event(at: event2017.end_at)
      expect(calendar.current_calendar_event).to eq nil
    end
  end

  describe '#next_change_at' do
    it 'returns end_at for current_calendar_event' do
      calendar.current_calendar_event = event2017
      expect(calendar.next_change_at(at: event2017.start_at)).to eq event2017.end_at
    end

    it 'returns start_at for first upcomming event when no current_calendar_event' do
      event2017
      expect(
        calendar.next_change_at(at: DateTime.new(2000,1,1))
      ).to eq event2017.start_at
    end

    it 'returns start_at for first upcomming event when `at` before ' \
       'current_calendar_event' do
      calendar.current_calendar_event = event2017
      expect(
        calendar.next_change_at(at: DateTime.new(2000,1,1))
      ).to eq event2017.start_at
    end

    it 'returns nil when no current_calendar_event and no further events' do
      expect(calendar.next_change_at(at: DateTime.new(2000,1,1))).to eq nil
    end
  end

  # describe '#oncall_at' do
  #   it 'returns nil when no user on call' do
  #     expect(calendar.oncall_at(at: DateTime.new(2000,1,1))).to be nil
  #   end

  #   it 'returns an calendar_events user' do
  #     event2017
  #     expect(
  #       calendar.oncall_at(at: DateTime.new(2017,2,2))
  #     ).to eq event2017.user
  #   end
  # end

  describe '#event_at' do
    context 'when no event in calendar' do
      it 'returns nil' do
        expect(calendar.event_at(at: Time.now)).to eq nil
      end
    end

    context 'when no event at particular date' do
      it 'returns nil' do
        event2017
        event2019
        # in the of two evets
        expect(calendar.event_at(at: DateTime.new(2018,2,2))).to eq nil
        # before the fist one
        expect(calendar.event_at(at: DateTime.new(2016,2,2))).to eq nil
        # after the last event
        expect(calendar.event_at(at: DateTime.new(2020,2,2))).to eq nil
      end
    end

    it 'returns an event' do
      event2017
      expect(calendar.event_at(at: event2017.start_at)).to eq event2017
      expect(calendar.event_at(at: event2017.end_at - 1.second)).to eq event2017
    end
  end

  describe '#ends_before_or_eql' do
    context 'when no event in calendar' do
      it 'returns nil' do
        expect(calendar.ends_before_or_eql(at: Time.now)).to eq nil
      end
    end

    context 'when no event before the given date' do
      it 'returns nil' do
        event2017
        expect(calendar.ends_before_or_eql(at: event2017.start_at)).to eq nil
        expect(calendar.ends_before_or_eql(at: event2017.start_at - 1.second)).to eq nil
        expect(calendar.ends_before_or_eql(at: event2017.start_at - 1.day)).to eq nil
        expect(calendar.ends_before_or_eql(at: event2017.start_at - 1.year)).to eq nil
      end
    end


    it 'returns the event' do
      event2017
      expect(calendar.ends_before_or_eql(at: event2017.end_at)).to eq event2017
      expect(calendar.ends_before_or_eql(at: event2017.end_at + 1.second)).to eq event2017
      expect(calendar.ends_before_or_eql(at: event2017.end_at + 1.day)).to eq event2017
    end

    it 'returns event which ends the least to the given time' do
      event2017
      event2018
      event2019
      expect(calendar.ends_before_or_eql(at: event2018.end_at)).to eq event2018
      expect(calendar.ends_before_or_eql(at: event2018.end_at + 1.second)).to eq event2018
      expect(calendar.ends_before_or_eql(at: event2018.end_at + 1.day)).to eq event2018
    end
  end

  describe '#starts_after_or_eql' do
    context 'when no event in calendar' do
      it 'returns nil' do
        expect(calendar.starts_after_or_eql(at: Time.now)).to eq nil
      end
    end

    context 'when no event after the given date' do
      it 'returns nil' do
        event2017
        expect(calendar.starts_after_or_eql(at: event2017.end_at)).to eq nil
        expect(calendar.starts_after_or_eql(at: event2017.end_at + 1.day)).to eq nil
        expect(calendar.starts_after_or_eql(at: event2017.end_at + 1.week)).to eq nil
      end
    end


    it 'returns the event' do
      event2017
      expect(calendar.starts_after_or_eql(at: event2017.start_at)).to eq event2017
      expect(calendar.starts_after_or_eql(at: event2017.start_at - 1.second)).to eq event2017
      expect(calendar.starts_after_or_eql(at: event2017.start_at - 1.day)).to eq event2017
      expect(calendar.starts_after_or_eql(at: event2017.start_at - 1.year)).to eq event2017
    end

    it 'returns event which ends the least to the given time' do
      event2017
      event2018
      event2019
      expect(calendar.starts_after_or_eql(at: event2018.start_at)).to eq event2018
      expect(calendar.starts_after_or_eql(at: event2018.start_at - 1.second)).to eq event2018
      expect(calendar.starts_after_or_eql(at: event2018.start_at - 1.day)).to eq event2018
      expect(calendar.starts_after_or_eql(at: event2018.start_at - 1.week)).to eq event2018
    end

  end
end
