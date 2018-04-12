require 'rails_helper'

RSpec.describe User, type: :model do

  subject { create(:user) }
  let(:team1) { create(:team, parent: create(:organization)) }
  let(:team2) { create(:team, parent: create(:organization)) }

  let(:subteam1)    { create(:team, parent: team1) }
  let(:subsubteam1) { create(:team, parent: subteam1) }

  let(:other_organization)  { create(:organization) }
  let(:other_team)           { create(:team, parent: other_organization) }

  let(:team1_user) { create(:user, teams: [ team1 ]) }
  let(:team2_user) { create(:user, teams: [ team1 ]) }

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

  describe '#visible_teams' do
    context 'when user is member of Team1' do
      it 'returned teams include the `team1`' do
        expect(team1_user.visible_teams).to include(subteam1)
      end

      it 'returns a subteam of the `team1`' do
        subteam1
        expect(team1_user.visible_teams).to include(subteam1)
      end

      it 'returns subteam of subteam' do
        subsubteam1
        expect(team1_user.visible_teams).to include(subsubteam1)
      end
    end

    context 'when user is member of organization but not a member of team' do
      it 'do not returns team' do
        team2
        expect(team1_user.visible_teams).to_not include(team2)
      end
    end

    context 'when user is not member of organization' do
      it 'do not return team' do
        other_team
        expect(team1_user.visible_teams).to_not include(other_team)
      end
    end
  end

  describe '#set_default_organization' do
    it 'do nothing when default_organization is set' do
      subject.default_organization = other_organization
      subject.send(:set_default_organization)
      expect(subject.default_organization).to eq other_organization
    end

    it 'keeps default_organization nil when user do not becomes to any organization' do
      subject.members.destroy_all
      subject.reload
      subject.default_organization = nil
      subject.send(:set_default_organization)
      expect(subject.default_organization).to eq nil
    end

    it 'set default_organization when it is nil' do
      subject.members.destroy_all
      subject.reload
      subject.default_organization = nil
      subject.teams << team1.organization
      subject.save!
      subject.send(:set_default_organization)
      expect(subject.default_organization).to eq team1.organization
    end

  end
end
