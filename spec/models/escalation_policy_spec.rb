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

  describe 'validations' do
    it 'validates uniqness of name for non-clones' do
      create(:escalation_policy, name: 'x')
      second = build(:escalation_policy, name: 'x')
      expect(second.valid?).to be false
      expect(second.errors[:name].size).to eq 1
    end
  end

  describe 'destroy of clone is prohibited' do
    it 'do not destroy item clonned item' do
      prime = create(:escalation_policy)
      subject = _clonned = prime.find_or_build_clone
      subject.save!
      expect {
        subject.destroy!
      }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end
  end

  describe 'modifications of clone are prohibited' do
    let(:escalation_rule) { create(:escalation_rule) }
    let(:prime) { create(:escalation_policy, escalation_rules: [escalation_rule]) }
    let(:clone) { c = prime.find_or_build_clone; c.new_record? && c.save!; c }

    it 'cannet change clone' do
      clone.name = 'xxxx'
      expect { clone.save! }.to raise_error(ActiveRecord::ReadOnlyRecord)
    end
  end

  describe '#find_or_build_clone' do
    let(:escalation_rule) { create(:escalation_rule) }
    let(:prime) { create(:escalation_policy, escalation_rules: [escalation_rule]) }

    it 'creates a clone when clone not exists' do
      clone = prime.find_or_build_clone
      expect(clone.new_record?).to be true
    end

    it 'returns a clone when clone exists' do
      clone1 = prime.find_or_build_clone
      clone1.save!
      clone2 = prime.find_or_build_clone
      expect(clone2.new_record?).to be false
    end

    it 'creates new clone when record change until last clone was created' do
      clone1 = prime.find_or_build_clone
      clone1.save!
      escalation_rule.delay = 1000
      escalation_rule.save!

      clone2 = prime.find_or_build_clone
      expect(clone2.new_record?).to be true
    end
  end
end
