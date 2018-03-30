require 'rails_helper'

RSpec.describe MembersController, type: :controller do

  let(:team)    { create(:team) }
  let(:user)    { create(:user, teams: [team]) }
  let(:other_user)          { create(:user) }
  let(:member)              { create(:member) }
  let(:valid_attributes)    { attributes_for(:member, user_id: other_user.id, team_id: nil) }
  let(:invalid_attributes)  { { access_level: nil } }

  before(:each) do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      member
      get :index, params: {team_id: team.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      member
      get :show, params: {id: member.to_param}
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
      member
      get :edit, params: {id: member.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Member" do
        team
        valid_attributes
        expect {
          post :create, params: {member: valid_attributes, team_id: team.to_param}
        }.to change(Member, :count).by(1)
      end

      it "redirects to the created member" do
        post :create, params: {member: valid_attributes, team_id: team.to_param}
        expect(response).to redirect_to(Member.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {member: invalid_attributes, team_id: team.to_param}
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {access_level: 10}
      }

      it "updates the requested member" do
        member
        put :update, params: {id: member.to_param, member: new_attributes}
        member.reload
        expect(member.access_level).to eq 10
      end

      it "redirects to the member" do
        member
        put :update, params: {id: member.to_param, member: valid_attributes}
        expect(response).to redirect_to(member)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        member
        put :update, params: {id: member.to_param, member: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested member" do
      member
      expect {
        delete :destroy, params: {id: member.to_param}
      }.to change(Member, :count).by(-1)
    end

    it "redirects to the members list" do
      member
      delete :destroy, params: {id: member.to_param}
      expect(response).to redirect_to(team_members_url(member.team))
    end
  end
end
