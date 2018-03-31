require "rails_helper"

RSpec.describe IntegrationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/org/myTeam/services/2/integrations").to route_to(controller:"integrations", action: "index", service_id: "2", full_path: "org/myTeam")
    end

    it "routes to #new" do
      expect(:get => "/org/myTeam/services/2/integrations/new").to route_to(controller:"integrations", action: "new", service_id: "2", full_path: "org/myTeam")
    end

    it "routes to #show" do
      expect(:get => "/org/myTeam/integrations/1").to route_to("integrations#show", :id => "1", full_path: "org/myTeam")
    end

    it "routes to #edit" do
      expect(:get => "/org/myTeam/integrations/1/edit").to route_to("integrations#edit", :id => "1", full_path: "org/myTeam")
    end

    it "routes to #create" do
      expect(:post => "/org/myTeam/services/2/integrations").to route_to(controller:"integrations", action: "create", service_id: "2", full_path: "org/myTeam")
    end

    it "routes to #update via PUT" do
      expect(:put => "/org/myTeam/integrations/1").to route_to("integrations#update", :id => "1", full_path: "org/myTeam")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/org/myTeam/integrations/1").to route_to("integrations#update", :id => "1", full_path: "org/myTeam")
    end

    it "routes to #destroy" do
      expect(:delete => "/org/myTeam/integrations/1").to route_to("integrations#destroy", :id => "1", full_path: "org/myTeam")
    end

  end
end
