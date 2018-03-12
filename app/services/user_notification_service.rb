class UserNotificationService
  attr_reader :user
  def initialize(user)
    @user = user
  end

  def execute(base_time: Time.now)
    EscalationPolicyService.new(
      user.personal_escalation_policy,
      incident
    ).execute(base_time: base_time)
  end
end
