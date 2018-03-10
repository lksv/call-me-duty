require 'rails_helper'

RSpec.describe User, type: :model do

  subject { create(:user) }

  describe 'FactoryBot.create(:user)' do

    it 'create user' do
      subject
      expect(subject.valid?).to eq true
    end

  end

  describe 'associations' do
    it 'can set team' do
      subject
      team = build(:team)
      subject.teams << build(:team)
      expect(team.users.include?(subject))
    end
  end
end
