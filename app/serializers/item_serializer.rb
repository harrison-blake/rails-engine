class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description

  attribute :unit_price do |object|
    object.unit_price.to_f
  end

  attribute :merchant_id, &:merchant_id
end
