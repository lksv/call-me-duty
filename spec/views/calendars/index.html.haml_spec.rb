require 'rails_helper'

RSpec.describe "calendars/index", type: :view do
  before(:each) do
    assign(:calendars, [
      Calendar.create!(
        :team => nil
      ),
      Calendar.create!(
        :team => nil
      )
    ])
  end

  it "renders a list of calendars" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
