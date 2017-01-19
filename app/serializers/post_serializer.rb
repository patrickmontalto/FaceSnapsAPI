class PostSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :caption, :photo_path, :tags
  has_one :user 
  has_many :comments
end
