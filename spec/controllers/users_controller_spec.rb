require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  let(:valid_attributes) do
    attributes_for(
      :user,
      password: '123456',
      password_confirmation: '123456'
    )
  end
  let(:invalid_attributes) { attributes_for(:user, email: ' ') }

  describe "GET #index" do
    it "returns a success response" do
      user
      get :index, params: {}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      user
      get :show, params: {id: user.to_param}
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
      user
      get :edit, params: {id: user.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new User" do
        expect {
          post :create, params: {user: valid_attributes}
        }.to change(User, :count).by(1)
      end

      it "redirects to the created user" do
        post :create, params: {user: valid_attributes}
        expect(response).to redirect_to(User.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {user: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {name: 'John Black'}
      }

      it "updates the requested user" do
        user
        put :update, params: {id: user.to_param, user: new_attributes}
        user.reload
        expect(user.name).to eq 'John Black'
      end

      it "redirects to the user" do
        user
        put :update, params: {id: user.to_param, user: valid_attributes}
        expect(response).to redirect_to(user)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        user
        put :update, params: {id: user.to_param, user: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user" do
      user
      expect {
        delete :destroy, params: {id: user.to_param}
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      user
      delete :destroy, params: {id: user.to_param}
      expect(response).to redirect_to(users_url)
    end
  end

end
