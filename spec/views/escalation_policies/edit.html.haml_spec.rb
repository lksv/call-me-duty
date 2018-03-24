require 'rails_helper'

RSpec.describe "escalation_policies/edit", type: :view do
  before(:each) do
    @escalation_policy = assign(:escalation_policy, EscalationPolicy.create!(
      :name => "MyString",
      :description => "MyText",
      :team => nil
    ))
  end

  it "renders the edit escalation_policy form" do
    render

    assert_select "form[action=?][method=?]", escalation_policy_path(@escalation_policy), "post" do

      assert_select "input[name=?]", "escalation_policy[name]"

      assert_select "textarea[name=?]", "escalation_policy[description]"

      assert_select "input[name=?]", "escalation_policy[team_id]"
    end
  end
end
