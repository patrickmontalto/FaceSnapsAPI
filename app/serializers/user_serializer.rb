class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :full_name, :email, :created_at, :updated_at, :auth_token, :photo_path
end
