# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def incident_created_mail
    UserMailer.incident_created_mail(user: user, messageable: incident)
  end

  def incident_acked_mail
    UserMailer.incident_acked_mail(user: user, messageable: incident)
  end

  def incident_resolved_mail
    UserMailer.incident_resolved_mail(user: user, messageable: incident)
  end

  def on_call_started_mail
    UserMailer.on_call_started_mail(user: user, messageable: calendar_event)
  end

  def on_call_finished_mail
    UserMailer.on_call_finished_mail(user: user, messageable: calendar_event)
  end

  private

  def team
    @team ||= Team.first || FactoryBot.create(:team)
  end

  def user
    @user ||= team.users&.first || FactoryBot.create(:user, teams: [ team ])
  end

  def incident
    @incident ||=
      team.incidents&.first || FactoryBot.create(:incident, team: team)
  end

  def calendar_event
    @calendar_event ||=
      team.calendar&.calendar_events&.first ||
      FactoryBot.create(:calendar_event, user: user, calendar: team.calendar)
  end
end
