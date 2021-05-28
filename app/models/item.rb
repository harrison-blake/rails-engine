class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  validates :name, :description, :unit_price, presence: true

  def self.find_by_price(min, max)
    min = 0 unless min
    max = 1000000 unless max

    where("unit_price >= #{min} and unit_price <= #{max}")
    .order(:name)
    .first
  end

  def self.find_by_search_query(name)
    where("name ILIKE ?", "%#{name}%")
    .order(:name)
    .first
  end

  def self.top_10_revenue(quantity)
    quantity = 10 unless quantity
    
    joins(invoice_items: {invoice: :transactions})
    .where("invoices.status='shipped' AND transactions.result='success'").group("items.id")
    .select("items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .order("revenue DESC")
    .limit(quantity)
  end
end
