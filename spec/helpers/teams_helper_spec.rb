require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TeamsHelper. For example:
#
# describe TeamsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TeamsHelper, type: :helper do
  let(:team) { create(:team) }

  describe '#show_team_path' do
    it 'contains teams name' do
      expect(helper.show_team_path(team, teams_cache: [team])).to include(team.name)
    end

    it 'contains link to teams incidents' do
      expect(helper.show_team_path(team, teams_cache: [team])).to include(team_incidents_path(team))
    end

    it 'contains parent name' do
      expect(helper.show_team_path(team, teams_cache: [team, team.parent])).to include(team.parent.name)
    end

    it 'contains link to parent teams incidents' do
      expect(
        helper.show_team_path(team, teams_cache: [team, team.parent])
      ).to include(team_incidents_path(team.parent))
    end
  end
end
