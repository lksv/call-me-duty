require 'rails_helper'

RSpec.describe CalendarsController, type: :controller do

  let(:team)                { create(:team) }
  let(:user)                { create(:user, teams: [team]) }
  let(:calendar)            { team.calendar }

  let(:valid_attributes)    { attributes_for(:calendar, team: nil, team_id: team.id) }
  let(:invalid_attributes)  { { current_calendar_event_id: 12345 } }

  before(:each) do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      calendar
      get :index, params: {}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      calendar
      get :show, params: {id: calendar.to_param}
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
      calendar
      get :edit, params: {id: calendar.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Calendar" do
        expect {
          post :create, params: {calendar: valid_attributes}
        }.to change(Calendar, :count).by(1)
      end

      it "redirects to the created calendar" do
        post :create, params: {calendar: valid_attributes}
        expect(response).to redirect_to(Calendar.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {calendar: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:other_team) { create(:team, users: [user]) }
      let(:new_attributes) {
        { team_id: other_team.id }
      }

      it "updates the requested calendar" do
        calendar
        put :update, params: {id: calendar.to_param, calendar: new_attributes}
        calendar.reload
        expect(calendar.team).to eq other_team
      end

      it "redirects to the calendar" do
        calendar
        put :update, params: {id: calendar.to_param, calendar: valid_attributes}
        expect(response).to redirect_to(calendar)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        skip('there is nothing what could be changed for now')
        calendar
        put :update, params: {id: calendar.to_param, calendar: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested calendar" do
      calendar
      expect {
        delete :destroy, params: {id: calendar.to_param}
      }.to change(Calendar, :count).by(-1)
    end

    it "redirects to the calendars list" do
      calendar
      delete :destroy, params: {id: calendar.to_param}
      expect(response).to redirect_to(calendars_url)
    end
  end
end
