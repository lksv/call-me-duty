require 'rails_helper'

RSpec.describe IncidentsController, type: :controller do

  let(:team)              { create(:team) }
  let(:valid_attributes)  { attributes_for(:incident, team_id: team.id) }
  let(:invalid_attributes) { attributes_for(:incident, title: ' ') }

  describe "GET #index" do
    it "returns a success response" do
      incident = Incident.create! valid_attributes
      get :index, params: {}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      incident = Incident.create! valid_attributes
      get :show, params: {id: incident.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      incident = Incident.create! valid_attributes
      get :edit, params: {id: incident.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Incident" do
        expect {
          post :create, params: {incident: valid_attributes}
        }.to change(Incident, :count).by(1)
      end

      it "redirects to the created incident" do
        post :create, params: {incident: valid_attributes}
        expect(response).to redirect_to(Incident.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {incident: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {title: 'new title'}
      }

      it "updates the requested incident" do
        incident = Incident.create! valid_attributes
        put :update, params: {id: incident.to_param, incident: new_attributes}
        incident.reload
        expect(incident.title).to eq 'new title'
      end

      it "redirects to the incident" do
        incident = Incident.create! valid_attributes
        put :update, params: {id: incident.to_param, incident: valid_attributes}
        expect(response).to redirect_to(incident)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        incident = Incident.create! valid_attributes
        put :update, params: {id: incident.to_param, incident: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested incident" do
      incident = Incident.create! valid_attributes
      expect {
        delete :destroy, params: {id: incident.to_param}
      }.to change(Incident, :count).by(-1)
    end

    it "redirects to the incidents list" do
      incident = Incident.create! valid_attributes
      delete :destroy, params: {id: incident.to_param}
      expect(response).to redirect_to(incidents_url)
    end
  end

end
