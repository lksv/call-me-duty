require 'rails_helper'

RSpec.describe "escalation_policies/new", type: :view do
  before(:each) do
    assign(:escalation_policy, EscalationPolicy.new(
      :name => "MyString",
      :description => "MyText",
      :team => nil
    ))
  end

  it "renders new escalation_policy form" do
    render

    assert_select "form[action=?][method=?]", escalation_policies_path, "post" do

      assert_select "input[name=?]", "escalation_policy[name]"

      assert_select "textarea[name=?]", "escalation_policy[description]"

      assert_select "input[name=?]", "escalation_policy[team_id]"
    end
  end
end
