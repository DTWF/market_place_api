class Api::V1::OrdersController < ApplicationController

  def index
    respond_with current_user.orders
  end
end
