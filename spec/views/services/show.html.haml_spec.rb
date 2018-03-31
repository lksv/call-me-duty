require 'rails_helper'

RSpec.describe "services/show", type: :view do
  let(:service)       { create(:service, description: 'some long description') }
  let(:team)          { service.team }

  before(:each) do
    @service = assign(:service, service)
    assign(:team, team)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(service.name)
    expect(rendered).to match(service.description)
  end

  it "renders attributes for Organization" do
    assign(:team, team.organization)
    render
    expect(rendered).to match(service.name)
    expect(rendered).to match(service.description)
  end
end
