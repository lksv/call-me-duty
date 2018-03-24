require "rails_helper"

RSpec.describe IntegrationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/integrations").to route_to("integrations#index")
    end

    it "routes to #new" do
      expect(:get => "/integrations/new").to route_to("integrations#new")
    end

    it "routes to #show" do
      expect(:get => "/integrations/1").to route_to("integrations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/integrations/1/edit").to route_to("integrations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/integrations").to route_to("integrations#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/integrations/1").to route_to("integrations#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/integrations/1").to route_to("integrations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/integrations/1").to route_to("integrations#destroy", :id => "1")
    end

  end
end
