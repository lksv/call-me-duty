require "rails_helper"

RSpec.describe EscalationPoliciesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/org/myTeam/escalation_policies").to route_to(controller: "escalation_policies", action: "index", full_path: "org/myTeam")
    end

    it "routes to #new" do
      expect(:get => "/org/myTeam/escalation_policies/new").to route_to(full_path: "org/myTeam", controller: "escalation_policies", action: "new")
    end

    it "routes to #show" do
      expect(:get => "/org/myTeam/escalation_policies/1").to route_to("escalation_policies#show", :id => "1", full_path: "org/myTeam")
    end

    it "routes to #edit" do
      expect(:get => "/org/myTeam/escalation_policies/1/edit").to route_to("escalation_policies#edit", :id => "1", full_path: "org/myTeam")
    end

    it "routes to #create" do
      expect(:post => "/org/myTeam/escalation_policies").to route_to(controller: "escalation_policies", action: "create", full_path: "org/myTeam")
    end

    it "routes to #update via PUT" do
      expect(:put => "/org/myTeam/escalation_policies/1").to route_to("escalation_policies#update", :id => "1", full_path: "org/myTeam")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/org/myTeam/escalation_policies/1").to route_to("escalation_policies#update", :id => "1", full_path: "org/myTeam")
    end

    it "routes to #destroy" do
      expect(:delete => "/org/myTeam/escalation_policies/1").to route_to("escalation_policies#destroy", :id => "1", full_path: "org/myTeam")
    end

  end
end
