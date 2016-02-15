class Post < ActiveRecord::Base
  before_save :update_slug_if_title_changed

  scope :latest,    ->{ order(created_at: :desc) }
  scope :published, ->{ where(published: true) }

  belongs_to :created_by, class_name: 'User'

  has_and_belongs_to_many :categories, class_name: 'Category'

  validates :created_by, presence: true
  validates :title,      presence: true

  private

  def update_slug_if_title_changed
    self.slug = "#{self.created_at.present? ? self.created_at.to_date.to_s : DateTime.now.to_date.to_s}-#{title.parameterize}" if title_changed?
  end
end
