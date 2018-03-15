require 'rails_helper'

RSpec.describe WebhookNotificationService do
  let(:incident)          { build(:incident) }
  let(:escalation_rule)   { double("escalation rule") }
  let(:gateway)           { build(:webhook_gateway) }
  subject do
    WebhookNotificationService.new(
      incident: incident,
      source: escalation_rule,
      gateway: gateway
    )
  end

  describe '#execute' do
    describe 'makes a http request' do
      it 'to URL specified in gateway.uri' do
        gateway = build(:webhook_gateway, uri: 'custom.example.com/any')
        subject = WebhookNotificationService.new(
          incident: incident,
          source: escalation_rule,
          gateway: gateway
        )
        expect(WebhookNotificationService).to(
          receive(:post).with('custom.example.com/any', anything()) do
            double('response', success?: true)
          end
        )
        subject.execute
      end

      it 'with body evaluated from gateway.templlate' do
        gateway = build(
          :webhook_gateway,
          template: '{{id|toJson}},title:{{title}},event:{{event}}'
        )
        subject = WebhookNotificationService.new(
          incident: incident,
          source: escalation_rule,
          gateway: gateway
        )
        incident.save!

        body = "\"#{incident.id}\",title:#{incident.title},event:incident_created"
        expect(WebhookNotificationService).to(
          receive(:post).with(anything(), hash_including(body: body)) do
            double('response', success?: true)
          end
        )
        subject.execute
      end

      ['POST', 'GET', 'PUT'].each do |method|
        it "makes POST requesst when gateway.http_method=#{method}" do
          gateway = build(:webhook_gateway, http_method: method)
          subject = WebhookNotificationService.new(
            incident: incident,
            source: escalation_rule,
            gateway: gateway
          )
          expect(WebhookNotificationService).to receive(method.downcase.intern) do
            double('response', success?: true)
          end
          subject.execute
        end
      end
    end

    describe 'creates a Message' do
      it 'creates new message' do
        expect {
          expect(WebhookNotificationService).to receive(:post) do
            double('response', success?: true)
          end
          subject.execute
        }.to change(Message, :count).by(1)
      end

      it 'fills Message attributes: event messageable and delivery_gateway' do
        expect(WebhookNotificationService).to receive(:post) do
          double('response', success?: true)
        end
        subject.execute
        expect(
          Message.find_by(
            event: 'incident_created',
            messageable: incident,
            delivery_gateway: gateway
          )
        ).to_not be nil
      end
    end

    context 'when http requesst returns any "success" status code' do
      it 'sets as Message as delivered' do
        expect(WebhookNotificationService).to receive(:post) do
          double('response', success?: true)
        end
        subject.execute
        expect(
          Message.find_by(
            event: 'incident_created',
            messageable: incident,
            delivery_gateway: gateway,
            status: 'delivered'
          )
        ).to_not be nil
      end
    end

    context 'when http requesst returns any "wrong" status code' do
      it 'sets as Message as delivery_fail' do
        expect(WebhookNotificationService).to receive(:post) do
          double('response', success?: false, response: 'ERROR MESSAGE')
        end
        subject.execute
        expect(
          Message.find_by(
            event: 'incident_created',
            messageable: incident,
            delivery_gateway: gateway,
            status: 'delivery_fail'
          )
        ).to_not be nil
      end
    end

    context 'when http request raise exception' do
      it 'sets as Message as delivery_fail' do
        expect {
          expect(WebhookNotificationService).to receive(:post) { raise HTTParty::Error, 'xxx' }
          subject.execute
        }.to_not raise_exception
        expect(
          Message.find_by(
            event: 'incident_created',
            messageable: incident,
            delivery_gateway: gateway,
            status: 'delivery_fail'
          )
        ).to_not be nil
      end
    end
  end

  describe '#build_payload' do
    it 'returns a template when template do not contain any var blocks' do
      ["abc\n1 2 3\n!@#", "w1 {{ w2", "word1 }} word2"].each do |template|
        result = subject.send(:build_payload, template, {})
        expect(result).to eq template
      end
    end

    describe "substitute a variables" do
      it 'substitute a variable in {{ }}' do
        result = subject.send(:build_payload, '{{var}}', {var: 'Yes'})
        expect(result).to eq 'Yes'

        result = subject.send(:build_payload, 'pre-{{var}}-post', {var: 'Yes'})
        expect(result).to eq 'pre-Yes-post'
      end

      it 'substitute a variable with spaces around {{ and/or }}' do
        result = subject.send(:build_payload, '{{ var}}', {var: 'Yes'})
        expect(result).to eq 'Yes'
        result = subject.send(:build_payload, '{{var }}', {var: 'Yes'})
        expect(result).to eq 'Yes'
        result = subject.send(:build_payload, '{{ var }}', {var: 'Yes'})
        expect(result).to eq 'Yes'
      end

      it 'substitute same variable several times' do
        template = "{{var1}} {{var1}}\n{{var1}}"
        vars = {var1: 'Yes'}
        result = subject.send(:build_payload, template, vars)
        expect(result).to eq "Yes Yes\nYes"
      end

      it 'substitute several variables' do
        template = '{{var1}} {{var2}}'
        vars = {var1: 'Yes', var2: 'No!'}
        result = subject.send(:build_payload, template, vars)
        expect(result).to eq 'Yes No!'
      end

      it 'substitute and escape a variable' do
        result = subject.send(:build_payload, '{{var|toJson}}', {var: 'Yes'})
        expect(result).to eq '"Yes"'

        result = subject.send(:build_payload, 'pre-{{var|toJson}}-post', {var: 'Yes'})
        expect(result).to eq 'pre-"Yes"-post'
      end

      it 'to empty string when variable do not exists' do
        result = subject.send(:build_payload, '{{var}}', {})
        expect(result).to eq ''
        result = subject.send(:build_payload, 'pre-{{var}}-post', {})
        expect(result).to eq 'pre--post'
        result = subject.send(:build_payload, 'pre-{{var|toJson}}-post', {})
        expect(result).to eq 'pre-""-post'
      end
    end
  end

  describe '#build_headers' do
    it 'sets Content-Type to application/json when not defined' do
      result = subject.send(:build_headers, {})
      expect(result['Content-Type']).to eq 'application/json'
    end

    it 'rewrites default Content-Type' do
      result = subject.send(:build_headers, { 'Content-Type' => 'text/plain' })
      expect(result['Content-Type']).to eq 'text/plain'
    end

    it 'it passes custom headers' do
      result = subject.send(:build_headers, { 'Custom' => 'abc' })
      expect(result['Custom']).to eq 'abc'
    end
  end
end
