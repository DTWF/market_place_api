class Api::V1::OrdersController < ApplicationController
  respond_to :json
  def index
    respond_with current_user.orders
  end

  def show
    respond_with current_user.orders.find(params[:id])
  end

  def create
    order = current_user.orders.build
    order.build_placements_with_product_ids_and_quantities(params[:order][:product_ids_and_quantities])
    if order.save
      OrderMailer.send_confirmation(order).deliver
      render json: order, status: 201, location: [:api, current_user, order]
    else
      render json: { errors: order.errors }, status: 422
    end
  end
end
