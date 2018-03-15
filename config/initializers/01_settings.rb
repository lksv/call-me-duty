class Settings < Settingslogic
  source "#{Rails.root}/config/application.yml"
  namespace Rails.env
end


Settings['email'] = Settingslogic.new({})
Settings['host'] ||= ENV['CMP_HOST'] || 'localhost'

Settings.email['from'] ||= ENV['CMP_EMAIL_FROM'] || "CMP@#{Settings.host}"
Settings.email['display_name'] ||= ENV['CMP_EMAIL_DISPLAY_NAME'] || 'CMP'
Settings.email['reply_to'] ||= ENV['CMP_EMAIL_REPLY_TO'] || "noreply@#{Settings.host}"
