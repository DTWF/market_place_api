class OrderProductSerializer < ProductSerializer

  attributes :id, :total

  has_many :products, serializer: OrderProductSerializer
  def include_user?
    false
  end
end
