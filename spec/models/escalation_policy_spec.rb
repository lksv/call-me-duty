require 'rails_helper'

RSpec.describe EscalationPolicy, type: :model do

  describe 'strip_attributes' do
    it 'strip spaces and new lines from name attribute' do
      subject = build(:escalation_policy, name: "  My  ES  \n ")
      subject.valid?
      expect(subject.name).to eq 'My ES'
    end
  end

  describe 'FactoryBot.create(:escalation_policy)' do
    subject { create(:escalation_policy) }
    it 'creates an EscalationPolicy' do
      expect(subject.valid?).to be true
      expect(subject.team.escalation_policies.include?(subject)).to be true
    end
  end
end
