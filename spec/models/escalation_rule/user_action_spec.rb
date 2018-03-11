require 'rails_helper'

RSpec.describe EscalationRule::UserAction, type: :model do
  let(:target) do
    build(:user)
  end

  let(:incident) do
    double('Incident Instance', title: 'TITLE', description: 'DESC')
  end

  subject { EscalationRule::UserAction.new(target, incident) }

  describe '#execute' do
    it 'Inicialize UserNotificationService with teams on-call user' do
      allow(UserNotificationService).to receive(:new).with(target) {
        double('UserNotificationService double', execute: -> {})
      }
      subject.execute
    end

    it 'raises exception when target is not an User' do
      target = build(:team)
      subject = EscalationRule::UserAction.new(target, incident)
      expect {
        subject.execute
      }.to raise_error(EscalationRule::InvalidTargetError)
    end

    it 'execute UserNotificationService' do
      allow_any_instance_of(UserNotificationService).to receive(:execute)
      subject.execute
    end
  end
end
