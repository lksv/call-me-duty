module CalendarsHelper
  def oncall_user(user)
    return 'nobody on call!' unless user

    if user.name.present?
      "%s <%s>" % [user.name, user.email]
    else
      user.email
    end
  end
end
