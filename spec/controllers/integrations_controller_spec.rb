require 'rails_helper'

RSpec.describe IntegrationsController, type: :controller do

  let(:team) { create(:team) }
  let(:user) { create(:user, teams: [team]) }

  let(:service)          { create(:service, team: team) }
  let(:valid_attributes) { attributes_for(:integration, service_id: service.id) }
  let(:invalid_attributes) { {type: 'invalid type'} }

  before(:each) do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      integration = Integration.create! valid_attributes
      get :index, params: {service_id: service.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      integration = Integration.create! valid_attributes
      get :show, params: {id: integration.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {service_id: service.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      integration = Integration.create! valid_attributes
      get :edit, params: {id: integration.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Integration" do
        expect {
          post :create, params: {service_id: service.to_param, integration: valid_attributes}
        }.to change(Integration, :count).by(1)
      end

      it "redirects to the created integration" do
        post :create, params: {service_id: service.to_param, integration: valid_attributes}
        expect(response).to redirect_to(integration_path(Integration.last))
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do 
        skip('dont know yet how to validate type')
        post :create, params: {service_id: service.to_param, integration: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      # let(:new_attributes) {
      #   {key: 'abc'}
      #   skip("Add a hash of attributes valid for your model")
      # }

      # it "updates the requested integration" do
      #   integration = Integration.create! valid_attributes
      #   put :update, params: {id: integration.to_param, integration: new_attributes}
      #   integration.reload
      #   skip("Add assertions for updated state")
      # end

      it "redirects to the integration" do
        integration = Integration.create! valid_attributes
        put :update, params: {id: integration.to_param, integration: valid_attributes}
        expect(response).to redirect_to(integration_path(integration))
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        integration = Integration.create! valid_attributes
        put :update, params: {id: integration.to_param, integration: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested integration" do
      integration = Integration.create! valid_attributes
      expect {
        delete :destroy, params: {id: integration.to_param}
      }.to change(Integration, :count).by(-1)
    end

    it "redirects to the integrations list" do
      integration = Integration.create! valid_attributes
      delete :destroy, params: {id: integration.to_param}
      expect(response).to redirect_to([service, :integrations])
    end
  end

end
