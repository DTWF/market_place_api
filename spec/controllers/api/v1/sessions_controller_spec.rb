require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

    describe "POST #create" do

      before(:each) do
        @user = FactoryBot.create(:user)
      end

      context "when the credentials are correct" do
        before(:each) do
          credentials = { email: @user.email, password: "12345678"}
          post :create, params: { session: credentials }
        end

        it "returns the user record corresponding to the given credentials" do
          @user.reload
          expect(json_response[:user][:auth_token]).to eql @user.auth_token
        end

        it "should return status 200" do
          expect(response.status).to eq(200)
        end
      end

      context "when the credentials are incorrect" do
        before(:each) do
          credentials = { email: @user.email, password: "invalidpassword"}
          post :create, params: { session: credentials }
        end

        it "returns json with an error" do
          expect(json_response[:errors]).to eql "Invalid email or password"
        end

        it "should return status 422" do
          expect(response.status).to eq(422)
        end
      end
    end

    describe "DELETE #destroy" do

      before(:each) do
        @user = FactoryBot.create(:user)
        sign_in @user#, store: false
        delete :destroy, params: { id: @user.auth_token }
      end

      it "should respond with 204" do
        expect(response.status).to eq(204)
      end
    end
end
