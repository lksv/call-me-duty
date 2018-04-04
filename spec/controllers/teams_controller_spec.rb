require 'rails_helper'

RSpec.describe TeamsController, type: :controller do

  let(:team) { create(:team) }
  let(:user)    { create(:user, teams: [team]) }
  let(:valid_attributes)    { attributes_for(:team, parent_id: team.id) }
  let(:invalid_attributes)  { {name:' '} }
  let(:organization)        { team.organization }
  let(:organization_valid_attributes)    { attributes_for(:organization) }

  before(:each) do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index, params: {}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      team
      get :show, params: {id: team.to_param}
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
      team
      get :edit, params: {id: team.to_param}
      expect(response).to be_success
    end
  end

  describe 'GET #calendar' do
    it 'returns a success response' do
      team
      get :calendar, params: {id: team.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Team" do
        team
        expect {
          post :create, params: {team: valid_attributes}
        }.to change(Team, :count).by(1)
      end

      it "redirects to the created team" do
        post :create, params: {team: valid_attributes}
        expect(response).to redirect_to(Team.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {team: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {name: 'new name'}
      }

      it "updates the requested team" do
        team
        put :update, params: {id: team.to_param, team: new_attributes}
        team.reload
        expect(team.name).to eq 'new name'
      end

      it "redirects to the team" do
        team
        put :update, params: {id: team.to_param, team: valid_attributes}
        expect(response).to redirect_to(team)
      end

      context "Organization" do
        it "redirects to the team" do
          put :update, params: {id: organization.to_param, team: organization_valid_attributes}
          expect(response).to redirect_to(organization.becomes(Team))
        end
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        team
        put :update, params: {id: team.to_param, team: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested team" do
      team
      expect {
        delete :destroy, params: {id: team.to_param}
      }.to change(Team, :count).by(-1)
    end

    it "redirects to the teams list" do
      team
      delete :destroy, params: {id: team.to_param}
      expect(response).to redirect_to(teams_url)
    end
  end

end
