require "rails_helper"

RSpec.describe CalendarsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "teams/2/calendars").to route_to({controller: "calendars", action: "index", team_id: "2"})
    end

    it "routes to #new" do
      expect(:get => "teams/2/calendars/new").to route_to({controller: "calendars", action: "new", team_id: "2"})
    end

    it "routes to #show" do
      expect(:get => "/calendars/1").to route_to({controller: "calendars", action: "show", id: '1'})
    end

    it "routes to #edit" do
      expect(:get => "/calendars/1/edit").to route_to({controller: "calendars", action: "edit", id: '1'})
    end

    it "routes to #create" do
      expect(:post => "teams/2/calendars").to route_to({controller: "calendars", action: "create", team_id: "2"})
    end

    it "routes to #update via PUT" do
      expect(:put => "/calendars/1").to route_to({controller: "calendars", action: "update", id: '1'})
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/calendars/1").to route_to({controller: "calendars", action: "update", id: '1'})
    end

    it "routes to #destroy" do
      expect(:delete => "/calendars/1").to route_to({controller: "calendars", action: "destroy", id: '1'})
    end

  end
end
