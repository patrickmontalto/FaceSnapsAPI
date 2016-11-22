class TagSerializer < ActiveModel::Serializer
  attributes :id, :name
  attribute :tagged_posts, key: :posts_count
end