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
