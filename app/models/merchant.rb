class Merchant < ApplicationRecord
  has_many :items

  def self.find_all_by_price(search)
    where("name ILIKE ?", "%#{search}%")
    .order(:name)
  end
end
