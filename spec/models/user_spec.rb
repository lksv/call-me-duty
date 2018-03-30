require 'rails_helper'

RSpec.describe User, type: :model do

  subject { create(:user) }
  let(:team1) { create(:team, parent: create(:organization)) }
  let(:team2) { create(:team, parent: create(:organization)) }

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

    it 'sould not return user in distict teams' do
      team1_user
      team2_user
      expect(subject.visible_users.size).to eq 0
    end
  end

  describe '#visible_delivery_gateways' do
    let(:team1_webhook) { create(:webhook_gateway, team: team1) }
    let(:team2_webhook) { create(:webhook_gateway, team: team2) }

    it 'returns delivery_gateways in users teams' do
      team1_webhook
      team2_webhook
      subject.teams << team1
      subject.teams << team2
      expect(subject.visible_delivery_gateways.size).to eq 2
      expect(subject.visible_delivery_gateways.all.to_a).to(
        include(team1_webhook, team2_webhook)
      )
    end

    it 'should not return delivery_gateway beloging to others team' do
      team1_webhook
      team2_webhook
      expect(subject.visible_delivery_gateways.size).to eq 0
    end
  end
end
