class PostSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :caption, :photo, :tags
end
