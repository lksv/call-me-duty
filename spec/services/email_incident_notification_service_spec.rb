require 'rails_helper'

RSpec.describe EmailIncidentNotificationService do
  let(:team)              { build(:team) }
  let(:incident)          { build(:incident) }
  let(:user)              { build(:user, teams: [team]) }
  let(:escalation_rule)   { double("escalation rule") }

  subject { EmailIncidentNotificationService.new(
    incident: incident,
    user: user,
    source: escalation_rule)
  }

  describe '#execute' do
    it 'should send email' do
      expect {
        subject.execute
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
      email = ActionMailer::Base.deliveries.last
      expect(email.to[0]).to eq user.email
      email_body = email.html_part.body.decoded
      expect(email_body).to match /incident/i
      expect(email_body).to match incident.title
    end

    it 'should create Message' do
      expect {
        subject.execute
      }.to change(Message, :count).by(1)
    end

    it 'should fill Message attributes: status, event, user, messageable, static_gateway' do
      subject.execute
      expect(
        Message.find_by(
          status: 'delivered',
          event: 'incident_created',
          user: user,
          messageable: incident,
          static_gateway: 'EmailGateway'
        )
      ).not_to be nil
    end

    it 'should set Message status to delivery_fail when UserMailer raises exception' do
      expect {
        expect(UserMailer).to receive(:incident_created) { raise "fake exception" }
        subject.execute
        expect(
          Message.find_by(
            status: 'delivery_fail',
            event: 'incident_created',
            user: user,
            messageable: incident,
            static_gateway: 'EmailGateway'
          )
        ).not_to be nil
      }.not_to raise_exception
    end
  end
end
