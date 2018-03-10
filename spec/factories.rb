FactoryBot.define do
  factory :escalation_rule do
    escalation_policy
    condition_type    'not_acked'
    action_type       'user'
    target            { escalation_policy.team.users.first || build(:user) }
    delay             0
  end

  factory :escalation_policy do
    sequence(:name) { |n| "EscalationPolicy no. #{n}" }
    team
  end

  ###

  factory :calendar_event do
    calendar
    user      { calendar.team.users.first }
    start_at  "2018-03-01 00:00:00"
    end_at    "2018-04-01 00:00:00"
  end


  factory :calendar do
    # need to create a team with a user
    team { create(:team, users: [create(:user)]) }
  end


  ###

  factory :user do
    sequence(:email) { |n| "name#{n}@example.com" }
    password        'myPassword'
  end

  factory :team do
    sequence(:name) { |n| "Team name no. #{n}" }
  end


  ###

  factory :service do
    sequence(:name) { |n| "Service name no. #{n}" }
    team
  end

  factory :integration do
    sequence(:name) { |n| "Integratin name no. #{n}" }
    type            :prometheus
    service
  end
end

