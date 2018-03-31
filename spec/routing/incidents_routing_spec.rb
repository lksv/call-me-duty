require "rails_helper"

RSpec.describe IncidentsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/teams/2/incidents").to route_to("incidents#index", team_id: '2')
    end

    it "routes to #new" do
      expect(:get => "/teams/2/incidents/new").to route_to("incidents#new", team_id: '2')
    end

    it "routes to #show" do
      expect(:get => "/incidents/1").to route_to("incidents#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/incidents/1/edit").to route_to("incidents#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/teams/2/incidents").to route_to("incidents#create", team_id: '2')
    end

    it "routes to #update via PUT" do
      expect(:put => "/incidents/1").to route_to("incidents#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/incidents/1").to route_to("incidents#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/incidents/1").to route_to("incidents#destroy", :id => "1")
    end

  end
end
