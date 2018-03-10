require 'rails_helper'

RSpec.describe CalendarEvent, type: :model do
  describe 'validations' do
    it "validates user is in Calendar's team" do
      subject = CalendarEvent.new(
        calendar: create(:calendar),
        user: create(:user)
      )
      expect(subject.valid?).to be_falsey
      expect(subject.errors[:user_id].size).to eq 1
    end
  end

  describe 'FactoryBot.create(:calendar_event)' do
    subject { create(:calendar_event) }
    it 'create CalendarEvent' do
      expect(subject.valid?).to be true
      expect(subject.calendar.calendar_events.include?(subject)).to be true
    end
  end

  describe 'association' do
    it 'it sets an user association' do
      subject = create(:calendar_event)
      expect(subject.user.calendar_events).to include(subject)
    end
  end

  let(:calendar)      { create(:calendar) }
  let(:event2017) { event(calendar, '2017-01-01 00:00:00', '2018-01-01 00:00:00') }
  let(:event2018) { event(calendar, '2018-01-01 00:00:00', '2019-01-01 00:00:00') }
  let(:event2019) { event(calendar, '2019-01-01 00:00:00', '2020-01-01 00:00:00') }

  describe '#previews' do
    context 'when no previews event' do
      it 'returns nil' do
        event2017
        expect(event2017.previews).to eq nil
      end
    end

    context 'when direct previews event exists' do
      it 'returns the one that lasts ends end before current start' do
        event2017
        event2018
        expect(event2018.previews).to eq event2017
      end
    end

    context 'when there is a gap between current and previews' do
      it 'returns the one the ends last before current start' do
        event2017
        event2019
        expect(event2019.previews).to eq event2017
      end
    end
  end

  describe '#next' do
    context 'when no next event' do
      it 'returns nil' do
        event2017
        expect(event2017.next).to eq nil
      end
    end

    context 'when direct next event exists' do
      it 'returns the one that starts first after current start' do
        event2017
        event2018
        expect(event2017.next).to eq event2018
      end
    end

    context 'when there is a gap between current and next' do
      it 'returns the one the start first after current start' do
        event2017
        event2019
        expect(event2017.next).to eq event2019
      end
    end
  end
end
