class ApplicationMailer < ActionMailer::Base
  default from: "#{Settings.email.display_name} <#{Settings.email.from}>"
  default reply_to: Settings.email.reply_to

  layout 'mailer'
end
