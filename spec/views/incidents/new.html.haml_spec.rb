require 'rails_helper'

RSpec.describe "incidents/new", type: :view do
  let(:team) { create(:team) }
  let(:user) { create(:user, teams: [team]) }

  before(:each) do
    assign(:incident, Incident.new())

    sign_in user
  end

  it "renders new incident form" do
    render

    assert_select "form[action=?][method=?]", incidents_path, "post" do
    end
  end
end
