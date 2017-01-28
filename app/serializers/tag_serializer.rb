class TagSerializer < ActiveModel::Serializer
  attributes :id, :name, :posts_count

  def posts_count
    if scope.current_user.nil?
      object.posts.public.uniq.count
    else
      object.posts_count(scope.current_user)
    end
  end
end