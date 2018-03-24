require 'rails_helper'

RSpec.describe "Integrations", type: :request do
  describe "GET /integrations" do
    it "works! (now write some real specs)" do
      get integrations_path
      expect(response).to have_http_status(200)
    end
  end
end
