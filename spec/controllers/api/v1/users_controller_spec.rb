require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe "GET #show" do
    before(:each) do
      @user = FactoryBot.create :user
      get :show, params: {id: @user.id , format: :json}
    end

    it "returns the information about a reporter on a hash" do
      user_response = json_response[:user]
      expect(user_response[:email]).to eql @user.email
    end

    it "should return status 200" do
      expect(response.status).to eq(200)
    end

    it "has the product ids as an embedded object" do
      user_response = json_response[:user]
      expect(user_response[:product_ids]).to eql []
    end
  end


  describe "POST #create" do

    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryBot.attributes_for :user
        post :create,  params: { user: @user_attributes }, format: :json
      end

      it "renders the json representation of the user just created" do
        user_response = json_response[:user]
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
        post :create,  params: { user: @invalid_user_attributes , format: :json }
      end

      it "renders an error json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the users could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it "should return status 422" do
        expect(response.status).to eq(422)
      end
    end
  end

  describe "PUT/PATCH #update" do

    context "when is successfully updated" do
      before(:each) do
        @user = FactoryBot.create :user
        api_authorization_header(@user.auth_token)
        patch :update, params: { id: @user.id,
                                        user: { email: "newmail@example.com" }, format: :json }
      end

      it "renders the json representation for the updated user" do
        user_response = json_response[:user]
        expect(user_response[:email]).to eql "newmail@example.com"
      end

      it "should return status 200" do
        expect(response.status).to eq(200)
      end

      context "when is not created" do
        before(:each) do
          @user = FactoryBot.create :user
          patch :update, params: { id: @user.id,
                                         user: {email: "bademail.com" }, format: :json}
        end

        it "renders an errors json" do
          user_response = json_response
          expect(user_response).to have_key(:errors)
        end

        it "renders the json errors on why the user could not be created" do
          user_response = json_response
          expect(user_response[:errors][:email]).to include "is invalid"
        end

        it { is_expected.to respond_with 422 }
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryBot.create :user
      api_authorization_header(@user.auth_token)
      delete :destroy, params: { id: @user.id, format: :json}
    end

    it "should return status 204" do
      expect(response.status).to eq(204)
    end
  end
end
