class LocationSerializer < ActiveModel::Serializer
  attributes :venue_id,  :name
  attribute  :latitude,  key: :lat
  attribute  :longitude, key: :lng
end