require 'rails_helper'

RSpec.describe Placement, type: :model do
  let(:placement) { FactoryBot.build :placement }
  subject { placement }

  it { is_expected.to respond_to :order_id }
  it { is_expected.to respond_to :product_id }
  it { is_expected.to belong_to :order }
  it { is_expected.to belong_to :product }
end
