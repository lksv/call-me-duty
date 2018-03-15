require 'rails_helper'

RSpec.describe DeliveryGateway, type: :model do
  describe 'strip_attributes' do
    it 'strip spaces and new lines from name attribute' do
      subject = build(:delivery_gateway, name: "  My DeliveryGateway   \n ")
      subject.valid?
      expect(subject.name).to eq 'My DeliveryGateway'
    end
  end

  describe 'FactoryBot.build(:delivery_gateway)' do
    subject { build(:delivery_gateway) }
    it 'creates delivery_gateway' do
      expect(subject.team).to_not be nil
    end
  end
end
