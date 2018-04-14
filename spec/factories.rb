FactoryBot.define do
  factory :webhook_gateway do
    sequence(:name)     { |n| "Webhook name no. #{n}" }
    type      'WebhookGateway'
    uri       'https://example.com/'
    template  '{ "title": {{{title | toJson}} }'
    http_method    'POST'
    team
  end

  factory :delivery_gateway do
    sequence(:name) { |n| "My Outbound Integration no. #{n}" }
    type 'WebhookGateway'
    team
    data "{}"
  end

  factory :message do
    event           :incident_created
    delivery_gateway
    user            do |message|
      team = message.delivery_gateway.team
      team.users.first || create(:user, teams: [ team ])
    end
    status          :created
    delivered_at    nil
    messageable do |message|
      create(:incident, team: message.delivery_gateway.team)
    end
  end

  factory :incident do
    team
    status          'created'
    priority        'critical'
    title           "My Incident"
    alert_trigged_count 1
  end

  factory :escalation_rule do
    escalation_policy
    condition_type    'not_acked'
    action_type       'user_email'
    targetable        { escalation_policy.team.users.first || build(:user) }
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
    sequence(:name)  { |n| "fake#{n} name" }
    password        'myPassword'
    organizations    do |user|
      org_name = 'default Org'
      [
        Organization.find_by(name: org_name) ||
          FactoryBot.create(:organization, name: org_name)
      ]
    end
    transient do
      teams []
    end

    after(:create) do |user, evaluator|
      evaluator.teams.each do |t|
        o = t.organization
        o.users << user unless o.users.include?(user)
        user.members.create(team: t, access_level: 100)
      end
    end
  end

  factory :organization do
    sequence(:name) { |n| "MyGigaCorp no. #{n}" }
    visibility_level   Team::PRIVATE
    type    'Organization'
  end

  factory :team do
    sequence(:name) { |n| "Team name no. #{n}" }
    visibility_level Team::PRIVATE
    parent do |o|
      o.parent = Organization.first ||
        FactoryBot.create(:organization)
    end
  end

  factory :member do
    access_level 100
    team
    user
  end

  ###

  factory :service do
    sequence(:name) { |n| "Service name no. #{n}" }
    team
  end

  factory :integration do
    sequence(:name) { |n| "Integratin name no. #{n}" }
    type            'Prometheus'
    service
  end
end

