require 'rails_helper'

RSpec.describe "services/new", type: :view do
  let(:service)       { build(:service) }
  let(:team)          { service.team }

  before(:each) do
    assign(:team, team)
    @service = assign(:service, service)
  end

  it "renders new service form" do
    render

    assert_select "form[action=?][method=?]", team_services_path(team), "post" do
      assert_select "input[name=?]", "service[name]"
      assert_select "textarea[name=?]", "service[description]"
      assert_select "select[name=?]", "service[team_id]"
    end
  end
end
