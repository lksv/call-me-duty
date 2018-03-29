require 'rails_helper'

RSpec.describe "services/index", type: :view do
  let(:team)          { create(:team) }
  let(:service1)       { create(:service, team: team) }
  let(:service2)       { create(:service, team: team) }

  before(:each) do
    assign(:team, team)
    assign(:services, [service1, service2])
  end

  it "renders a list of services" do
    render
    assert_select 'tr>td', text: 'Show', :count => 2
    assert_select 'tr>td', text: service1.name, :count => 1
    assert_select 'tr>td', text: service2.name, :count => 1
  end
end
