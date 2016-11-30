class CategoriesPost < ApplicationRecord
  belongs_to :category
  belongs_to :post

  validates :category, presence: true
  validates :post,     presence: true
end
