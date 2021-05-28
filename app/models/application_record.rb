class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.paginate(perPage, page)
    perPage = 20 if perPage.nil? || perPage.to_i < 1
    page = 1 if page.nil? || page.to_i < 1

    order(id: :asc).limit(perPage).offset((page.to_i - 1) * perPage.to_i)
  end
end
