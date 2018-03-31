require "rails_helper"

RSpec.describe ServicesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/org/myTeam/services").to route_to(controller: "services", action: "index", full_path: "org/myTeam")
    end

    it "routes to #new" do
      expect(:get => "/org/myTeam/services/new").to route_to(controller: "services", action: "new", full_path: "org/myTeam")
    end

    it "routes to #show" do
      expect(:get => "/org/myTeam/services/1").to route_to("services#show", :id => "1", full_path: "org/myTeam")
    end

    it "routes to #edit" do
      expect(:get => "/org/myTeam/services/1/edit").to route_to("services#edit", :id => "1", full_path: "org/myTeam")
    end

    it "routes to #create" do
      expect(:post => "/org/myTeam/services").to route_to(controller: "services", action: "create", full_path: "org/myTeam")
    end

    it "routes to #update via PUT" do
      expect(:put => "/org/myTeam/services/1").to route_to("services#update", :id => "1", full_path: "org/myTeam")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/org/myTeam/services/1").to route_to("services#update", :id => "1", full_path: "org/myTeam")
    end

    it "routes to #destroy" do
      expect(:delete => "/org/myTeam/services/1").to route_to("services#destroy", :id => "1", full_path: "org/myTeam")
    end

  end
end
