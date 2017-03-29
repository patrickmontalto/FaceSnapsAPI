class LocationSerializer < ActiveModel::Serializer
	attributes :id, :venue_id, :name, :lat, :lng
	
  def lat
  	object.latitude
  end

  def lng
  	object.longitude
  end
end