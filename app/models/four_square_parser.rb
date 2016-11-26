class FourSquareParser
	def self.parse(venues)
		venues.map { |x| { :id   => x.id,
											 :name => x.name,
											 :lat  => x.location.lat,
											 :lng  => x.location.lng } }
	end
end