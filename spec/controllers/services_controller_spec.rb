require 'rails_helper'

RSpec.describe ServicesController, type: :controller do

  let(:team) { create(:team) }
  let(:user) { create(:user, teams: [team]) }

  let(:valid_attributes) {
    attributes_for(:service).merge(team_id: team.to_param)
  }

  let(:invalid_attributes) {
    {team_id: team.to_param, name: ''}
  }

  before(:each) do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      service = Service.create! valid_attributes
      get :index, params: {team_id: team.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      service = Service.create! valid_attributes
      get :show, params: {id: service.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {team_id: team.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      service = Service.create! valid_attributes
      get :edit, params: {id: service.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Service" do
        expect {
          post :create, params: {team_id: team.to_param, service: valid_attributes}
        }.to change(Service, :count).by(1)
      end

      it "redirects to the created service" do
        post :create, params: {team_id: team.to_param, service: valid_attributes}
        expect(response).to redirect_to(Service.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {team_id: team.to_param, service: invalid_attributes}
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
        service = Service.create! valid_attributes
        put :update, params: {id: service.to_param, service: new_attributes}
        service.reload
        expect(service.name).to eq 'new name'
      end

      it "redirects to the service" do
        service = Service.create! valid_attributes
        put :update, params: {id: service.to_param, service: valid_attributes}
        expect(response).to redirect_to(service)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        service = Service.create! valid_attributes
        put :update, params: {id: service.to_param, service: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested service" do
      service = Service.create! valid_attributes
      expect {
        delete :destroy, params: {id: service.to_param}
      }.to change(Service, :count).by(-1)
    end

    it "redirects to the services list" do
      service = Service.create! valid_attributes
      delete :destroy, params: {id: service.to_param}
      expect(response).to redirect_to([team, :services])
    end
  end

end
