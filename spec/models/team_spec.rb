require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'strip_attributes' do
    it 'strip spaces and new lines from name attribute' do
      t1 = Team.new(name: "  My  Name  \n ")
      t1.valid?
      expect(t1.name).to eq 'My Name'
    end
  end

  describe 'FactoryBot.create(:team)' do
    subject { create(:team) }
    it 'creates team' do
      subject
    end

    it 'can set user' do
      t = subject
      t.users << build(:user)
    end
  end
end
