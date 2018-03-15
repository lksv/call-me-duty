require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

module MessageBirdMock

  MessageBirdMessage = Struct.new(:source, :destination, :flow)

  def self.deliveries
    @@deliveries ||= []
  end

  def self.clean
    @deliveries = []
  end
end

module MessageBirdHelpers
  def stub_call_requests
    @@stub_messagebird_calls_request ||= "123-abc-000"
    @@stub_messagebird_calls_request.succ!

    stub_request(:post, 'https://voice.messagebird.com/calls').to_return do |request|
      payload = JSON.parse(request.body)
      voice_call_item =  MessageBirdMock::MessageBirdMessage.new(
        payload['source'],
        payload['destination'],
        payload['flow']
      )
      MessageBirdMock.deliveries << voice_call_item

      {
        status: 200,
        headers: {'Content-Type' => 'application/json'},
        body: {
          data:[{ id: @@stub_messagebird_calls_request }]
        }.to_json
      }
    end
  end
end
