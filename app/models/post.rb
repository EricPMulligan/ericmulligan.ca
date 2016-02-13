class Post < ActiveRecord::Base
  before_save :update_slug_if_title_changed

  scope :latest,    ->{ order(created_at: :desc) }
  scope :published, ->{ where(published: true) }

  belongs_to :created_by, class_name: 'User'

  validates :created_by, presence: true
  validates :title,      presence: true

  private

  def update_slug_if_title_changed
    self.slug = title.parameterize if title_changed?
  end
end
