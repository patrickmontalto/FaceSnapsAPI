class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :full_name, :email, :created_at, :updated_at, :auth_token, 
  :photo_path, :following, :posts_count, :followers_count, :following_count, :private, :relationship

  def following
    if scope.current_user.nil?
      return false
    end
    scope.current_user.following?(object)
  end

  def relationship
    if scope.current_user.nil?
      return false
    end
    incoming_status = StatusReporter.outgoing(scope.current_user, object)
    outgoing_status = StatusReporter.incoming(scope.current_user, object)
    {incoming_status: incoming_status, outgoing_status: outgoing_status}
  end

end
