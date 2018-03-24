json.extract! incident, :id, :iid, :status, :title, :description, :team_id, :integration_id, :service_id, :escalation_policy_id, :priority, :created_at, :updated_at
json.url incident_url(incident, format: :json)
