require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:webhook_gateway) { build(:webhook_gateway) }

  describe 'static_gateway validations' do
    it 'pass validation when static_gateway is nil' do
      subject = Message.new
      subject.valid?
      expect(subject.errors[:static_gateway].size).to be 0
    end

    it 'pass validation when static_gateway is known class' do
      subject = Message.new(static_gateway: 'VoiceCallMessagebirdGateway')
      subject.valid?
      expect(subject.errors[:static_gateway].size).to be 0
    end

    it 'fails validating when static_gateway is unknown class' do
      subject = Message.new(static_gateway: 'UnknownClass')
      subject.valid?
      expect(subject.errors[:static_gateway].size).to be 1
    end
  end

  describe 'validates exclusifity of static_gateway and delivery_gateway' do
    it 'fails validating when static_gateway and delivery_gateway is not defined' do
      subject = Message.new
      subject.valid?
      expect(subject.errors[:base].size).to be 1
    end

    it 'fails validating when static_gateway and delivery_gateway is not defined' do
      subject = Message.new(
        static_gateway: 'VoiceCallMessagebirdGateway',
        delivery_gateway: webhook_gateway
      )
      subject.valid?
      expect(subject.errors[:base].size).to be 1
    end

    it 'pass validation when only delivery_gateway is defined' do
      subject = Message.new(
        delivery_gateway: webhook_gateway
      )
      subject.valid?
      expect(subject.errors[:base].size).to be 0
    end

    it 'pass validation when only static_gateway is defined' do
      subject = Message.new(
        static_gateway: 'VoiceCallMessagebirdGateway',
      )
      subject.valid?
      expect(subject.errors[:base].size).to be 0
    end
  end

  describe '#delivery_gateway' do
    it 'returns delivery_gateway when delivery_gateway is defined' do
      subject = Message.new(delivery_gateway: webhook_gateway)
      expect(subject.delivery_gateway).to eq webhook_gateway
    end

    it 'returns instance of static_gateway when static_gateway is defined' do
      subject = Message.new(static_gateway: 'VoiceCallMessagebirdGateway')
      expect(subject.delivery_gateway).to(
        be_instance_of StaticGateway::VoiceCallMessagebirdGateway
      )
    end
  end
end
