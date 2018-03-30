require "rails_helper"

RSpec.describe MembersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/teams/2/members").to route_to(controller: "members", action: "index", team_id: "2")
    end

    it "routes to #new" do
      expect(:get => "/teams/2/members/new").to route_to(controller: "members", action: "new", team_id: "2")
    end

    it "routes to #show" do
      expect(:get => "/members/1").to route_to("members#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/members/1/edit").to route_to("members#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "teams/2/members").to route_to(controller: "members", action: "create", team_id: "2")
    end

    it "routes to #update via PUT" do
      expect(:put => "/members/1").to route_to("members#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/members/1").to route_to("members#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/members/1").to route_to("members#destroy", :id => "1")
    end

  end
end
