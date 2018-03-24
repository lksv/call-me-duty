require 'rails_helper'

RSpec.describe "integrations/new", type: :view do
  before(:each) do
    assign(:integration, Integration.new(
      :name => "MyString",
      :key => "MyString",
      :type => "",
      :service => nil
    ))
  end

  it "renders new integration form" do
    render

    assert_select "form[action=?][method=?]", integrations_path, "post" do

      assert_select "input[name=?]", "integration[name]"

      assert_select "input[name=?]", "integration[key]"

      assert_select "input[name=?]", "integration[type]"

      assert_select "input[name=?]", "integration[service_id]"
    end
  end
end
