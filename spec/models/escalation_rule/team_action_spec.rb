require 'rails_helper'

RSpec.describe EscalationRule::TeamAction, type: :model do
  let(:target) do
    build(:team)
  end

  let(:incident) do
    double('Incident Instance', title: 'TITLE', description: 'DESC')
  end

  subject { EscalationRule::TeamAction.new(target, incident) }

  describe '#execute' do
    it 'Inicialize UserNotificationService with teams on-call user' do
      allow(UserNotificationService).to receive(:new).with(target.on_call) {
        double('UserNotificationService double', execute: -> {})
      }
      subject.execute
    end

    it 'raises exception when target is not an Team' do
      target = build(:user)
      subject = EscalationRule::TeamAction.new(target, incident)
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
