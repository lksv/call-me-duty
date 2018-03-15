class Nexmo::SmsService
  def clinet
    @clinet ||= Nexmo::Client.new(api_key: Settings.nexmo.api_key, api_secret: Settings.nexmo.secret)
  end

  def send(phone:, message:)
    response = client.sms.send(from: 'CMP', to: phone, text: message)

    if response.messages.first.status == '0'
      puts "Sent message id=#{response.messages.first.message_id}"
      response.message.first.message_id
    else
      puts "Error: #{response.messages.first.error_text}"
    end
  end
end
