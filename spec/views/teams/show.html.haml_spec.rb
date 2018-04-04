require 'rails_helper'

RSpec.describe "teams/show", type: :view do
  let(:team)          { create(:team) }
  let(:organization)  { team.organization }

  before(:each) do
    @team = assign(:team, team)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(team.name)
    expect(rendered).to match(/Visibility Level/)
    expect(rendered).to match('private')  #visibility_level
  end

  it 'renders attributes for Organization' do
    assign(:team, organization)
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(organization.name)
    expect(rendered).to match(/Visibility Level/)
    expect(rendered).to match('private')  #visibility_level
  end
end
