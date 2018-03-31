require 'rails_helper'

RSpec.describe "services/edit", type: :view do
  let(:service)       { create(:service) }
  let(:team)          { service.team }

  before(:each) do
    assign(:team, team)
    @service = assign(:service, service)
  end

  it "renders the edit service form" do
    render

    assert_select "form[action=?][method=?]", team_service_path(team, @service), "post" do
      assert_select "input[name=?]", "service[name]"
      assert_select "textarea[name=?]", "service[description]"
    end
  end

  it "renders the edit service form" do
    assign(:team, team.organization)
    render

    assert_select "form[action=?][method=?]", team_service_path(team.organization, @service), "post" do
      assert_select "input[name=?]", "service[name]"
      assert_select "textarea[name=?]", "service[description]"
    end
  end
end
