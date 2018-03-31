require 'rails_helper'

RSpec.describe ServicesController, type: :controller do

  let(:team)    { create(:team) }
  let(:user)    { create(:user, teams: [team]) }
  let(:service) { create(:service, team: team) }

  let(:valid_attributes) {
    attributes_for(:service).merge(full_path: team.to_param)
  }

  let(:invalid_attributes) {
    {full_path: team.to_param, name: ''}
  }

  before(:each) do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      service
      get :index, params: {full_path: team.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      service
      get :show, params: {id: service.to_param, full_path: team.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {full_path: team.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      service
      get :edit, params: {id: service.to_param, full_path: team.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Service" do
        expect {
          post :create, params: {full_path: team.to_param, service: valid_attributes}
        }.to change(Service, :count).by(1)
      end

      it "redirects to the created service" do
        post :create, params: {full_path: team.to_param, service: valid_attributes}
        expect(response).to redirect_to(team_service_path(team, Service.last))
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {full_path: team.to_param, service: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: 'new name' }
      }

      it "updates the requested service" do
        service
        put :update, params: {id: service.to_param, service: new_attributes, full_path: team.to_param}
        service.reload
        expect(service.name).to eq 'new name'
      end

      it "redirects to the service" do
        service
        put :update, params: {id: service.to_param, service: valid_attributes, full_path: team.to_param}
        expect(response).to redirect_to(team_service_path(team, service))
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        service
        put :update, params: {id: service.to_param, service: invalid_attributes, full_path: team.to_param}
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested service" do
      service
      expect {
        delete :destroy, params: {id: service.to_param, full_path: team.to_param}
      }.to change(Service, :count).by(-1)
    end

    it "redirects to the services list" do
      service
      delete :destroy, params: {id: service.to_param, full_path: team.full_path}
      expect(response).to redirect_to([team, :services])
    end
  end

end
