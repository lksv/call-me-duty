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

    assert_select "form[action=?][method=?]", service_path(@service), "post" do
      assert_select "input[name=?]", "service[name]"
      assert_select "textarea[name=?]", "service[description]"
    end
  end
end
