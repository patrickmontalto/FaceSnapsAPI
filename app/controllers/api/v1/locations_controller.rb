class Api::V1::LocationsController < ApplicationController
  before_action :authenticate_with_token!

	# GET /locations/:venue-id
	def show
		location = Location.find_by(venue_id: params[:venue_id])

		render json: location, :root => "data", adapter: :json
	end

	# GET /locations/:venue-id/posts/recent
	def posts
		location = Location.find_by(venue_id: params[:venue_id])
		posts = paginate location.posts, :per_page => 20

		render json: { :data => {:posts => posts} }, adapter: :json
	end

	# GET /locations/search
	def search
		# Get lat and lng
		# Submit to FourSquare API with distance of 500m
		# Return paginated list via json { :venue_id, :latitude, :longitude, :name }
	end

end