require 'rails_helper'

RSpec.describe "integrations/index", type: :view do
  let(:team)              { create(:team) }
  let(:service)           { create(:service, team: team) }
  let(:integration1)      { create(:integration, service: service) }
  let(:integration2)      { create(:integration, service: service) }

  before(:each) do
    assign(:integrations, [integration1, integration2])
    assign(:service, service)
  end

  it "renders a list of integrations" do
    render
    assert_select 'tr>td', text: 'Show', :count => 2
    assert_select 'tr>td', text: integration1.name, :count => 1
    assert_select 'tr>td', text: integration2.name, :count => 1
    assert_select 'tr>td', text: integration1.key, :count => 1
    assert_select 'tr>td', text: integration2.key, :count => 1
    assert_select 'tr>td', text: integration1.type
    assert_select 'tr>td', text: integration2.service_name
  end
end
