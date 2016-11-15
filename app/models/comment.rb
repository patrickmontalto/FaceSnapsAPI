class Comment < ActiveRecord::Base
  default_scope { order('created_at DESC') }
  belongs_to :post
  belongs_to :user
  validates :post, :user, :text, presence: true
  validates :text, length: { maximum: 300 }


  def tags
    text.scan(/\B#\w+/).map { |t| t[1..-1].downcase }
  end
  
end
