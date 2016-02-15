class Category < ActiveRecord::Base
  belongs_to :created_by, class_name: 'User'

  has_and_belongs_to_many :posts, class_name: 'Post'

  validates :name,       presence: true
  validates :created_by, presence: true
end
