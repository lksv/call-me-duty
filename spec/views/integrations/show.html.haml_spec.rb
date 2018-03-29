require 'rails_helper'

RSpec.describe "integrations/show", type: :view do
  let(:team)              { create(:team) }
  let(:service)           { create(:service, team: team) }
  let(:integration)       { create(:integration, service: service) }

  before(:each) do
    @integration = assign(:integration, integration)
    assign(:service, service)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Key/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/Service/)

    expect(rendered).to match(integration.name)
    expect(rendered).to match(integration.key)
    expect(rendered).to match(integration.type)
    expect(rendered).to match(integration.service_name)

  end
end
