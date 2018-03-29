require 'rails_helper'

RSpec.describe "teams/new", type: :view do
  let(:team)     { build(:team) }

  before(:each) do
    @team = assign(:team, team)
  end

  it "renders new team form" do
    render

    assert_select "form[action=?][method=?]", teams_path, "post" do
      assert_select "input[name=?]", "team[name]"
    end
  end
end
