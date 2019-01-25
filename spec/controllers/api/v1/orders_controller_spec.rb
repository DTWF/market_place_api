require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  describe "GET #index" do
    before(:each) do
      current_user = FactoryBot.create :user
      api_authorization_header current_user.auth_token
      4.times { FactoryBot.create :order, user: current_user}
      get :index, user_id: current_user.id

      it "returns 4 order records from the user " do
        orders_response = json_response[:orders]
        expect(orders_response.size).to eq(4)
      end

      it { is_expected.to respond_with 200 }
    end
  end
end
