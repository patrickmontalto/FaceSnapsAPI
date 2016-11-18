class TagSerializer < ActiveModel::Serializer
  attributes :id, :name, :post_count
end