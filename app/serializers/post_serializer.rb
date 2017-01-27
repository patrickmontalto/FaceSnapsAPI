class PostSerializer < ActiveModel::Serializer

  attributes :id, :user_id, :caption, :photo_path, :tags, :liked_by_user, :like_count
  has_one :user 
  has_many :comments
  has_many :likes

  def liked_by_user
    if scope.current_user.nil?
      return false
    end
    object.liked_by_user?(scope.current_user)
  end

end
