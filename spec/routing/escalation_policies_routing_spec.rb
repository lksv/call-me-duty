require "rails_helper"

RSpec.describe EscalationPoliciesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/escalation_policies").to route_to("escalation_policies#index")
    end

    it "routes to #new" do
      expect(:get => "/escalation_policies/new").to route_to("escalation_policies#new")
    end

    it "routes to #show" do
      expect(:get => "/escalation_policies/1").to route_to("escalation_policies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/escalation_policies/1/edit").to route_to("escalation_policies#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/escalation_policies").to route_to("escalation_policies#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/escalation_policies/1").to route_to("escalation_policies#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/escalation_policies/1").to route_to("escalation_policies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/escalation_policies/1").to route_to("escalation_policies#destroy", :id => "1")
    end

  end
end
