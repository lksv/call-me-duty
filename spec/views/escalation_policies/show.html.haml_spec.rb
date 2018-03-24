require 'rails_helper'

RSpec.describe "escalation_policies/show", type: :view do
  before(:each) do
    @escalation_policy = assign(:escalation_policy, EscalationPolicy.create!(
      :name => "Name",
      :description => "MyText",
      :team => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
