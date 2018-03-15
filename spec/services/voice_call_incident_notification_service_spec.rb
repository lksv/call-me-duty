require 'rails_helper'

RSpec.describe VoiceCallIncidentNotificationService do
  let(:team)              { build(:team) }
  let(:incident)          { build(:incident) }
  let(:user)              { build(:user, teams: [team]) }
  let(:escalation_rule)   { double("escalation rule") }

  subject { VoiceCallIncidentNotificationService.new(
    incident: incident,
    user: user,
    source: escalation_rule)
  }

  def stub_success_response
    stub_request(:post, 'https://voice.messagebird.com/calls')
      .to_return(
        status:200,
        body: '{"data":[{"id":"123-456-abc"}]}',
        headers: {'Content-Type' => 'application/json'}
      )
  end

  def stub_failed_response
    stub_request(:post, 'https://voice.messagebird.com/calls')
      .to_return(
        status:401,
        body: '{"data":[{"id":"123-456-abc"}]}',
        headers: {'Content-Type' => 'application/json'}
      )
  end

  describe '#execute' do
    it 'should create Message' do
      stub_success_response
      expect { subject.execute }.to change(Message, :count).by(1)
    end

    it 'should fill Message attributes: status, event, user, messageable, static_gateway' do
      stub_success_response
      subject.execute
      expect(
        Message.find_by(
          status: 'delivering',
          event: 'incident_created',
          user: user,
          messageable: incident,
          static_gateway: 'VoiceCallMessagebirdGateway'
        )
      ).not_to be nil
    end

    it 'should fill Message attribute gateway_request_uid form the response' do
      stub_success_response
      subject.execute
      message = Message.find_by(
        status: 'delivering',
        event: 'incident_created',
        user: user,
        messageable: incident,
        static_gateway: 'VoiceCallMessagebirdGateway'
      )
      expect(message.gateway_request_uid).to eq '123-456-abc'
    end

    it 'should set Message status to delivery_fail when request fails' do
      stub_failed_response
      expect {
        subject.execute
        expect(
          Message.find_by(
            status: 'delivery_fail',
            event: 'incident_created',
            user: user,
            messageable: incident,
            static_gateway: 'VoiceCallMessagebirdGateway'
          )
        ).not_to be nil
      }.not_to raise_exception
    end

    it 'should set Message status to delivery_fail when HTTParty raises exception' do
      expect {
        expect(VoiceCallIncidentNotificationService).to receive(:post) { raise "fake exception" }
        subject.execute
        expect(
          Message.find_by(
            status: 'delivery_fail',
            event: 'incident_created',
            user: user,
            messageable: incident,
            static_gateway: 'VoiceCallMessagebirdGateway'
          )
        ).not_to be nil
      }.not_to raise_exception
    end
  end
end
