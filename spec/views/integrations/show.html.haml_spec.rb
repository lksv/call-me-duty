require 'rails_helper'

RSpec.describe "integrations/show", type: :view do
  before(:each) do
    @integration = assign(:integration, Integration.create!(
      :name => "Name",
      :key => "Key",
      :type => "Type",
      :service => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Key/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(//)
  end
end
