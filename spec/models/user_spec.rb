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
