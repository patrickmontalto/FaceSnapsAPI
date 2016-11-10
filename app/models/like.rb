class Like < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates :post, :user, presence: true
  validates_uniqueness_of :post_id, scope: [:user_id]
end
