class User < ActiveRecord::Base
  include Clearance::User

  validates :remember_token,     length: { maximum: 128 }
  validates :confirmation_token, length: { maximum: 128 }
end
