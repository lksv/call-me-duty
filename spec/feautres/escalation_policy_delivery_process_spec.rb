require 'rails_helper'
require 'active_support/testing/time_helpers'

RSpec.describe "EscalationPolicy delivery process", type: :feature do
  include MessageBirdHelpers
  include ActiveSupport::Testing::TimeHelpers

  before { ActionMailer::Base.deliveries = [] }

  let(:team)              { create(:team) }
  let(:calendar)          { team.calendar }
  let(:user_oncall)       { create(:user, email: 'john@example.com', phone: '420608111111', teams: [team]) }
  let(:user_bob)          { create(:user, email: 'bob@example.com', phone: '420608222222', teams: [team]) }
  let(:webhook)           { create(:webhook_gateway) }
  let(:calendar_event)    do
    create(
      :calendar_event,
      calendar: team.calendar,
      user: user_oncall,
      start_at: '2018-01-01 09:00:00',
      end_at: '2018-01-01 11:00:00'
    )
  end

  let(:escalation_policy) do
    ep = create(:escalation_policy, team: team)
    create(:escalation_rule, escalation_policy: ep, delay: 1, action_type: 'on_call_email', targetable: nil)
    create(:escalation_rule, escalation_policy: ep, delay: 2, action_type: 'on_call_voice_call', targetable: nil)

    create(:escalation_rule, escalation_policy: ep, delay: 3, action_type: 'user_email', targetable: user_bob)
    create(:escalation_rule, escalation_policy: ep, delay: 4, action_type: 'user_voice_call', targetable: user_bob)

    create(:escalation_rule, escalation_policy: ep, delay: 5, action_type: 'webhook', targetable: webhook)
    ep
  end

  let(:incident)          { create(:incident, team: team) }

  describe 'EscalationPolicyService.execute' do
    it 'shoud deliver all escalation_rules' do
      calendar.current_calendar_event = calendar_event
      calendar.save!


      stub_call_requests

      # expect(a_request(:post, 'https://example.com/')).to have_been_made.once
      webhooks = []
      stub_request(:post, "https://example.com/").to_return do |request|
        webhooks << request.uri.to_s
        { status: 200, body: '' }
      end

      Sidekiq::Testing.inline! do
        expect {
          service = EscalationPolicyService.new(escalation_policy, incident)
          service.execute()
        }.to change(Message, :count).by(5)
      end

      # Each Escalation Rules create a message during the delivering
      messages = Message.all.to_a
      expect(messages[0].static_gateway).to eq 'EmailGateway'
      expect(messages[0].status).to eq 'delivered'
      expect(messages[0].user).to eq user_oncall

      expect(messages[1].static_gateway).to eq 'VoiceCallMessagebirdGateway'
      expect(messages[1].status).to eq 'delivering'
      expect(messages[1].user).to eq user_oncall

      expect(messages[2].static_gateway).to eq 'EmailGateway'
      expect(messages[2].status).to eq 'delivered'
      expect(messages[2].user).to eq user_bob

      expect(messages[3].static_gateway).to eq 'VoiceCallMessagebirdGateway'
      expect(messages[3].status).to eq 'delivering'
      expect(messages[3].user).to eq user_bob

      expect(messages[4].static_gateway).to be nil
      expect(messages[4].delivery_gateway).to eq webhook
      expect(messages[4].status).to eq 'delivered'
      expect(messages[4].user).to be nil

      # There are two EscalationRules for email delivery
      emails = ActionMailer::Base.deliveries
      expect(emails.size).to eq 2
      expect(emails[0].to[0]).to eq user_oncall.email
      expect(emails[1].to[0]).to eq user_bob.email

      # There are two EscalationRules for voice call delivery
      voice_calls = MessageBirdMock.deliveries
      expect(voice_calls[0].destination).to eq user_oncall.phone
      expect(voice_calls[1].destination).to eq user_bob.phone

      # There is one webhook
      expect(webhooks.size).to eq 1
      expect(webhooks.first).to eq 'https://example.com:443/'
    end

    it 'should not deliver when incident is snoozed'

    it 'should not deliver when incident is resolved' do
      calendar.current_calendar_event = calendar_event
      calendar.save!

      stub_call_requests

      Sidekiq::Testing.inline! do
        expect {
          incident.update_column(:status, :resolved)
          service = EscalationPolicyService.new(escalation_policy, incident)
          service.execute(base_time: Time.new(2018,1,1))
        }.to change(Message, :count).by(0)
      end

      emails = ActionMailer::Base.deliveries
      expect(emails.size).to eq 0
      emails = ActionMailer::Base.deliveries
      expect(emails.size).to eq 0
    end

    it 'should not deliver any messages after incident is closed by escalation_rule' #do
    #   create(:escalation_rule, escalation_policy: escalation_policy, delay: 0, action_type: 'close_incident')
    #   expect {
    #     service = EscalationPolicyService.new(escalation_policy, incident)
    #     service.execute(base_time: Time.new(2018,1,1))
    #   }.to change(Message, :count).by(0)
    # end
  end
end
