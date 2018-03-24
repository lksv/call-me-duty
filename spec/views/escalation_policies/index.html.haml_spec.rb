require 'rails_helper'

RSpec.describe "escalation_policies/index", type: :view do
  before(:each) do
    assign(:escalation_policies, [
      EscalationPolicy.create!(
        :name => "Name",
        :description => "MyText",
        :team => nil
      ),
      EscalationPolicy.create!(
        :name => "Name",
        :description => "MyText",
        :team => nil
      )
    ])
  end

  it "renders a list of escalation_policies" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
