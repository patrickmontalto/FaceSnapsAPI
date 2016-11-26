require 'singleton'

class FourSquareClient
	include Singleton

	def initialize
		client_id = Rails.application.secrets.foursquare_client_id
		client_secret = Rails.application.secrets.foursquare_client_secret
		@client = Foursquare2::Client.new(:client_id => client_id, :client_secret => client_secret, :api_version => '20161126')
	end

	def get_venues(lat, lng, query)
		ll = "#{lat},#{lng}"
		results = @client.search_venues(:ll => ll, :query => query, :radius => 800)[:venues]
		FourSquareParser.parse(results)
	end
end