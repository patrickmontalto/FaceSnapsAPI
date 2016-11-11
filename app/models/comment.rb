class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  validates :post, :user, :text, presence: true
end
