require 'rails_helper'

RSpec.describe "EscalationPolicies", type: :request do
  describe "GET /escalation_policies" do
    it "works! (now write some real specs)" do
      get escalation_policies_path
      expect(response).to have_http_status(200)
    end
  end
end
