require 'rails_helper'

RSpec.describe Order, type: :model do

  let(:order) { FactoryBot.build :order }
  subject { order }

  it { is_expected.to respond_to :total }
  it { is_expected.to respond_to :user_id }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :placements }
  it { is_expected.to have_many(:products).through(:placements) }

  describe "#set_total!" do
    before(:each) do
      product_1 = FactoryBot.create :product, price: 100
      product_2 = FactoryBot.create :product, price: 85
      @order = FactoryBot.build :order, product_ids: [ product_1.id, product_2.id ]
    end

    it "returns the total amount for the products" do
      expect{ @order.set_total! }.to change {@order.total}.from(0).to(185)
    end
  end

  describe "#build_placements_with_product_ids_and_quantities" do
    before(:each) do
      product_1 = FactoryBot.create :product, price: 100, quantity: 5
      product_2 = FactoryBot.create :product, price: 85, quantity: 10
      @product_ids_and_quantities =  [[product_1.id, 2], [product_2.id, 3]]
    end

    it "builds 2 placements for the orders" do
      expect {order.build_placements_with_product_ids_and_quantities(@product_ids_and_quantities)}.to change{order.placements.size}.from(0).to(2)
    end
  end
end
