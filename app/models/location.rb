class Location < ActiveRecord::Base
	has_many :post_locations
  has_many :posts, -> { order(created_at: :desc) },
           :through => :post_locations

  validates :latitude, :longitude, :name, :venue_id, presence: true
  validates :venue_id, uniqueness: true
end
