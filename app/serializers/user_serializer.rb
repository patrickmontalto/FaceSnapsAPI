class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :created_at, :updated_at, :auth_token
end
