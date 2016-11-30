class Post < ApplicationRecord
  before_validation :update_slug_if_title_changed

  scope :latest,    ->{ order(created_at: :desc) }
  scope :published, ->{ where(published: true) }

  belongs_to :created_by, class_name: 'User'

  has_many :categories_posts
  has_many :categories, through: :categories_posts

  validates :created_by, presence: true
  validates :title,      presence: true
  validates :slug,       presence: true,
                         uniqueness: {
                           case_sensitive: false
                         }

  private

  def update_slug_if_title_changed
    date = if self.created_at.present?
             self.created_at.strftime('%Y-%m-%d')
           else
             DateTime.now.strftime('%Y-%m-%d')
           end
    self.slug = "#{date}-#{title.parameterize}" if title_changed?
  end
end
