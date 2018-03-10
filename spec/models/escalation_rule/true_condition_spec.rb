require 'rails_helper'

RSpec.describe EscalationRule::TrueCondition, type: :model do
  let(:incident) do
    double(
           'Incident Instance',
           resolved?: false
    )
  end

  subject { EscalationRule::TrueCondition.new(incident) }

  describe '#execute' do
    it 'returns true when incident not resolved' do
      expect(subject.execute).to be true
    end

    it 'returns false when incident is resolved' do
      expect(incident).to receive(:resolved?).and_return(true)
      expect(subject.execute).to be false
    end
  end
end
