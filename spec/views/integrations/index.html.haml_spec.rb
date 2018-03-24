require 'rails_helper'

RSpec.describe "integrations/index", type: :view do
  before(:each) do
    assign(:integrations, [
      Integration.create!(
        :name => "Name",
        :key => "Key",
        :type => "Type",
        :service => nil
      ),
      Integration.create!(
        :name => "Name",
        :key => "Key",
        :type => "Type",
        :service => nil
      )
    ])
  end

  it "renders a list of integrations" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Key".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
