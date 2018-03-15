require 'rails_helper'

RSpec.describe EscalationRule::WebhookAction, type: :model do
  let(:target) { build(:webhook_gateway) }
  let(:escalation_rule) { double('EscalationRule') }

  let(:incident) do
    double('Incident Instance', title: 'TITLE', description: 'DESC')
  end


  subject { EscalationRule::WebhookAction.new(target, incident, escalation_rule) }

  describe '#execute' do
    it 'Inicialize WebhookNotificationService with webhook instance' do
      allow(WebhookNotificationService).to receive(:new).with(
        incident: incident,
        gateway: target,
        source: escalation_rule
      ) { double('WebhookNotificationService double', execute: -> {}) }
      subject.execute
    end

    it 'raises exception when target is not an Webhook' do
      target = build(:user)
      subject = EscalationRule::WebhookAction.new(target, incident, escalation_rule)
      expect {
        subject.execute
      }.to raise_error(EscalationRule::InvalidTargetError)
    end

    it 'execute WebhookNotificationService' do
      allow_any_instance_of(WebhookNotificationService).to receive(:execute).and_return(nil)
      subject.execute
    end
  end
end
