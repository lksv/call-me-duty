require 'rails_helper'

RSpec.describe Webhook, type: :model do
  subject { create(:webhook) }
  describe 'FactoryBot.create(:webhook)' do
    it 'creates webhook' do
      subject
      expect(subject.team).to_not be nil
    end
  end

  describe 'associations' do
    it 'it sets an team association' do
      expect(subject.team.webhooks).to include(subject)
    end
  end

  describe '#render' do
    it 'returns as String' do
      expect(subject.render).to be_a String
    end

    it 'returns exact template when no {{ }} used' do
      subject.template = 'A custom string'
      expect(subject.render).to eq subject.template
    end

    context 'variable subtitution' do
      context 'normal variable' do
        it 'returns substutute {{ }} with a variable value' do
          subject.template = '{{ variable }}'
          expect(subject.render(variable: 'RESULT')).to eq 'RESULT'
        end

        it 'evaluates variable with numbers' do
          subject.template = '{{ v_A_r_1_a }}'
          expect(subject.render(v_A_r_1_a: 'RESULT')).to eq 'RESULT'
        end

        it 'evaluates {{ }} without spaces' do
          subject.template = '{{var}}'
          expect(subject.render(var: 'RESULT')).to eq 'RESULT'
        end
      end

      context 'escaped variables' do
        it 'returns substutute {{ }} with a variable value' do
          subject.template = '{{ variable_escaped }}'
          expect(subject.render(variable: 'RESULT')).to eq '"RESULT"'
        end
        it 'evaluates escaped variables {{ }} without spaces' do
          subject.template = '{{var_escaped}}'
          expect(subject.render(var: 'RESULT')).to eq '"RESULT"'
        end
      end

      it 'evaluates multiple use of same variable' do
        subject.template = '{{var}} {{var}}'
        expect(subject.render(var: 'RESULT')).to eq 'RESULT RESULT'
      end

      it 'evaluates normal and escaped use of same variable ' do
        subject.template = '{{var}} {{var_escaped}}'
        expect(subject.render(var: 'RESULT')).to eq 'RESULT "RESULT"'
      end

      it 'evaluates several variables' do
        subject.template = 'var1:{{var1}} var2:{{var2}}'
        expect(subject.render(var1: 'R1', var2: 'R2')).to eq 'var1:R1 var2:R2'
      end

      it 'multiline several variables' do
        subject.template = "var1:{{var1}}\n\nvar2:{{var2}}"
        expect(
          subject.render(var1: "L1\nL2", var2: 'R2')
        ).to eq "var1:L1\nL2\n\nvar2:R2"
      end

    end
  end
end
