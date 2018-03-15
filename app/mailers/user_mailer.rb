class UserMailer < ApplicationMailer
  def incident_created(user:, incident:)
    @user = user
    @incident = incident
	  mail(to: user.email, subject: 'New incident was created')
  end

  def incident_acked(user:, incident:)
    @user = user
    @incident = incident
	  mail(to: user.email, subject: ('Incident #%s was acknowledged' % @incident.to_param))
  end

  def incident_resolved(user:, incident:)
    @user = user
    @incident = incident
	  mail(to: user.email, subject: ('Incident #%s was resolved' % @incident.to_param))
  end

  def on_call_started(user:, calendar_event:)
    @user = user
    @calendar_event = calendar_event
	  mail(to: user.email, subject: 'Your on call shift just started')
  end

  def on_call_finished(user:, calendar_event:)
    @user = user
    @calendar_event = calendar_event
	  mail(to: user.email, subject: 'Your on call shift just finished')
  end
end
