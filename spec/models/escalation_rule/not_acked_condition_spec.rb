require 'rails_helper'

RSpec.describe EscalationRule::NotAckedCondition, type: :model do
  let(:incident) do
    double(
           'Incident Instance',
           resolved?: false,
           acked?: false,
           snoozed?: false
    )
  end

  subject { EscalationRule::NotAckedCondition.new(incident) }

  describe '#execute' do
    it 'returns true when incident not resolved and not snoozed' do
      expect(subject.execute).to be true
    end

    it 'returns true when incident not acked and not snoozed' do
      expect(subject.execute).to be true
    end

    it 'returns false when incident is snoozed' do
      expect(incident).to receive(:snoozed?).and_return(true)
      expect(subject.execute).to be false
    end

    it 'returns false when incident is acked' do
      expect(incident).to receive(:acked?).and_return(true)
      expect(subject.execute).to be false
    end

    it 'returns false when incident is resolved' do
      expect(incident).to receive(:resolved?).and_return(true)
      expect(subject.execute).to be false
    end
  end
end
