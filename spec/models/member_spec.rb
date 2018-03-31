require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:team) { create(:team) }
  let(:user) { create(:user) }
  let(:member) { create(:member, user: user, team: team) }
  let(:organization) { team.organization }

  it 'validates uniqness of user in team' do
    member
    subject = team.members.new(user: user, access_level: 10)
    subject.valid?
    expect(subject.errors[:user].size).to eq 1
  end

  it 'validates that user is in organization' do
    user = create(:user)
    team.members.new(user: user, access_level: 10)
    subject.valid?
    expect(subject.errors[:user].size).to eq 1
  end


  describe 'validates that user cannot be destroy when is in teams' do
    it 'destroy organization when user is not in sub teams' do
      expect {
        organization.members.where(user: user).destroy_all
      }.not_to raise_exception
    end

    it 'prevent destroy when user is in sub-team' do
      member
      expect {
        subject = organization.members.where(user: user).first
        subject.destroy
      }.to change(Member, :count).by(0)
    end
  end

end
