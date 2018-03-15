require 'rails_helper'

RSpec.describe WebhookGateway, type: :model do
  subject     { build(:webhook_gateway) }

  describe 'FactoryBot.build(:webhook_gateway)' do
    subject { create(:webhook_gateway) }
    it 'creates webhook_gateway' do
      expect(subject.team).to_not be nil
    end
  end

  describe 'default attributes' do
    it 'set headeres to empty hash when headeres not defined' do
      subject = WebhookGateway.new
      expect(subject.headers).to eq Hash.new
    end

    it 'set http_method to POST when empty' do
      subject = WebhookGateway.new
      expect(subject.http_method).to eq 'POST'
    end

    it 'set do not set http_method when present' do
      subject = WebhookGateway.new(http_method: 'GET')
      expect(subject.http_method).to eq 'GET'
    end

    it 'set default template whne empyt' do
      subject = WebhookGateway.new
      expect(subject.template).to match '"event":'
      expect(subject.template).to match '"id":'
    end
  end

  describe '#personal?' do
    it 'returns false' do
      expect(subject.personal?).to be false
    end
  end
end
