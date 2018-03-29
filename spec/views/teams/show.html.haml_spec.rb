require 'rails_helper'

RSpec.describe "teams/show", type: :view do
  let(:team)     { create(:team) }

  before(:each) do
    @team = assign(:team, team)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(team.name)
  end
end
