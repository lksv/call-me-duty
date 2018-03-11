require 'rails_helper'

RSpec.describe EscalationRule::WebhookAction, type: :model do
  let(:target) do
    build(:webhook)
  end

  let(:incident) do
    double('Incident Instance', title: 'TITLE', description: 'DESC')
  end

  subject { EscalationRule::WebhookAction.new(target, incident) }

  describe '#execute' do
    it 'Inicialize WebhookService with webhook instance' do
      allow(WebhookService).to receive(:new).with(target) {
        double('WebhookService double', execute: -> {})
      }
      subject.execute
    end

    it 'raises exception when target is not an Webhook' do
      target = build(:user)
      subject = EscalationRule::WebhookAction.new(target, incident)
      expect {
        subject.execute
      }.to raise_error(EscalationRule::InvalidTargetError)
    end

    it 'execute WebhookService' do
      allow_any_instance_of(WebhookService).to receive(:execute)
      subject.execute
    end
  end
end
