require 'rails_helper'

RSpec.describe "users/index", type: :view do
  let(:user1)  { create(:user) }
  let(:user2)  { create(:user) }

  before(:each) do
    assign(:users, [user1, user2])
  end

  it "renders a list of users" do
    render
    assert_select 'tr>td', text: user1.email, count: 1
    assert_select 'tr>td', text: user2.email, count: 1
    assert_select 'tr>td', text: 'Show', count: 2
  end
end
