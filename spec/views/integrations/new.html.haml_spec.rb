require 'rails_helper'

RSpec.describe "integrations/new", type: :view do
  let(:team)              { create(:team) }
  let(:service)           { create(:service, team: team) }
  let(:integration)       { build(:integration, service: service) }

  before(:each) do
    assign(:integration, integration)
    assign(:service, service)
  end

  it "renders new integration form" do
    render

    assert_select "form[action=?][method=?]", service_integrations_path(service), "post" do
      assert_select "input[name=?]", "integration[name]"
      assert_select "select[name=?]", "integration[type]"
      assert_select "select[name=?]", "integration[service_id]"
    end
  end
end
