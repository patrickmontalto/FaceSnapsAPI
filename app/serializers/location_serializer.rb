class LocationSerializer < ActiveModel::Serializer
  attribute :id
  attributes :venue_id,  :name
  attribute  :latitude,  key: :lat
  attribute  :longitude, key: :lng
end