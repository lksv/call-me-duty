require 'rails_helper'

RSpec.describe Service, type: :model do
  describe 'strip_attributes' do
    it 'strip spaces and new lines from name attribute' do
      subject = Service.new(name: "  My  service  \n ")
      subject.valid?
      expect(subject.name).to eq 'My service'
    end
  end

  describe 'FactoryBot.create(:service)' do
    subject { create(:service) }
    it 'creates service' do
      expect(subject.team).to_not be nil
    end
  end

  describe 'associations' do
    it 'sets an team association' do
      subject = create(:service, team: create(:team))
      expect(subject.team.services).to include(subject)
    end
  end
end
