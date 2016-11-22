class Location < ActiveRecord::Base
  validates :latitude, :longitude, :name, presence: true

end
