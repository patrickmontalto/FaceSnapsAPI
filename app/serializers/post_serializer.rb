class PostSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :caption, :base64_image, :tags, 
  has_one :user 
  has_many :comments
end
