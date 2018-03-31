require 'rails_helper'

RSpec.describe "integrations/edit", type: :view do
  let(:team)              { create(:team) }
  let(:service)           { create(:service, team: team) }
  let(:integration)       { create(:integration, service: service) }

  before(:each) do
    @integration = assign(:integration, integration)
    assign(:service, service)
    assign(:team, team)
  end

  it "renders the edit integration form" do
    render

    assert_select "form[action=?][method=?]", team_integration_path(team, @integration), "post" do
      assert_select "input[name=?]", "integration[name]"
      assert_select "select[name=?]", "integration[type]"
      assert_select "select[name=?]", "integration[service_id]"
    end
  end
end
