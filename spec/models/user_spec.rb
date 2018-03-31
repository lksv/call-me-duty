require 'rails_helper'

RSpec.describe User, type: :model do

  subject { create(:user) }
  let(:team1) { create(:team, parent: create(:organization)) }
  let(:team2) { create(:team, parent: create(:organization)) }

  let(:other_organization)  { create(:organization) }
  let(:other_team)           { create(:team, parent: other_organization) }

  describe 'FactoryBot.create(:user)' do
    it 'create user' do
      subject
      expect(subject.valid?).to eq true
    end

  end

  describe 'associations' do
    it 'can set team' do
      subject
      team = build(:team)
      subject.teams << build(:team)
      expect(team.users.include?(subject))
    end
  end

  describe '#visible_users' do
    let(:team1_user) { create(:user, teams: [ team1 ]) }
    let(:team2_user) { create(:user, teams: [ team1 ]) }

    it 'returns users in same teams' do
      team1_user
      team2_user
      subject.teams << team1
      subject.teams << team2
      expect(subject.visible_users.size).to eq 3
      expect(subject.visible_users.all.to_a).to(
        include(subject, team1_user, team2_user)
      )
    end

    it 'sould not return user in other organizations' do
      other_organization
      expect(subject.visible_users).not_to include(other_organization)
      expect(subject.visible_users).not_to include(other_team)
    end
  end
end
