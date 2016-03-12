class Category < ApplicationRecord
  before_validation :update_slug_if_name_changed

  belongs_to :created_by, class_name: 'User'

  has_and_belongs_to_many :posts, class_name: 'Post'

  validates :name,       presence: true
  validates :created_by, presence: true
  validates :slug,       presence: true,
                         uniqueness: {
                           case_sensitive: false
                         }

  private

  def update_slug_if_name_changed
    self.slug = self.name.parameterize if self.name.present? && self.name_changed?
  end
end
