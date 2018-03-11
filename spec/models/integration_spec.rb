require 'rails_helper'

RSpec.describe Integration, type: :model do
  describe 'strip_attributes' do
    it 'strip spaces and new lines from name attribute' do
      subject = create(:integration, name: "  My  service  \n ")
      expect(subject.name).to eq 'My service'
    end
  end

  describe 'has_secure_token :key' do
    it 'initialize key to random token' do
      i1 = create(:integration)
      i2 = create(:integration)
      expect(i1.key).to_not eq i2.key
    end
  end

  describe 'FactoryBot.create(:integration)' do
    subject { create(:integration) }
    it 'creates integration' do
      subject
      expect(subject.service).to_not be nil
    end
  end

  describe 'associations' do
    it 'it sets an service association' do
      subject = create(:integration)
      expect(subject.service.integrations).to include(subject)
    end
  end
end
