require 'rails_helper'

RSpec.describe EscalationRule::BaseAction, type: :model do
  let(:target) do
    build(:user)
  end

  let(:incident) do
    double('Incident Instance', title: 'TITLE', description: 'DESC')
  end

  let(:escalation_rule) { double("EscalationRule") }

  subject { EscalationRule::BaseAction.new(target, incident, escalation_rule) }

  describe '#title' do
    it 'contains incidents title' do
      expect(subject.title).to match /#{Regexp.escape(incident.title)}/
    end
  end

  describe '#message' do
    it 'contains incident description if provided' do
      expect(subject.message).to match /#{Regexp.escape(incident.description)}/
    end
  end
end
