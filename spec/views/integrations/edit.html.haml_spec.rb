require 'rails_helper'

RSpec.describe "integrations/edit", type: :view do
  before(:each) do
    @integration = assign(:integration, Integration.create!(
      :name => "MyString",
      :key => "MyString",
      :type => "",
      :service => nil
    ))
  end

  it "renders the edit integration form" do
    render

    assert_select "form[action=?][method=?]", integration_path(@integration), "post" do

      assert_select "input[name=?]", "integration[name]"

      assert_select "input[name=?]", "integration[key]"

      assert_select "input[name=?]", "integration[type]"

      assert_select "input[name=?]", "integration[service_id]"
    end
  end
end
