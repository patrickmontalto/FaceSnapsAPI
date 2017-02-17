class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :full_name, :email, :created_at, :updated_at, :auth_token, :photo_path, :following, :posts_count, :followers_count, :following_count

  def following
    if scope.current_user.nil?
      return false
    end
    scope.current_user.following?(object)
  end
end
