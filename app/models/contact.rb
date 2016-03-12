class Contact < ApplicationRecord
  belongs_to :read_by, class_name: 'User'

  scope :unread, ->{ where(read_at: nil) }

  validates :email, presence: true
  validates :body,  presence: true
end