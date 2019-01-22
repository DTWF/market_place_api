require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe "GET #show" do
    before(:each) do
      @user = FactoryBot.create :user
      get :show, params: {id: @user.id , format: :json}
    end

    it "returns the information about a reporter on a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email
    end

    it "should return status 200" do
      expect(response.status).to eq(200)
    end
  end


  describe "POST #create" do

    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryBot.attributes_for :user
        post :create,  params: { user: @user_attributes }, format: :json
      end

      it "renders the json representation of the user just created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it "should return status 201" do
        expect(response.status).to eq(201)
      end
    end

    context "when is not created" do
      before(:each) do
        @invalid_user_attributes = { password: "12345678",
                                     password_confirmation: "12345678"}
        post :create,  params: { user: @invalid_user_attributes }, format: :json
      end

      it "renders an error json" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the users could not be created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it "should return status 422" do
        expect(response.status).to eq(422)
      end
    end
  end
end
