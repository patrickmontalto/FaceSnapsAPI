class Api::V1::RelationshipsController < ApplicationController
	before_action :authenticate_with_token!
	respond_to :json

	# GET /users/self/follows
	def current_user_follows
		follows(current_user)
	end

	# GET /users/user-id/follows
	def follows(user = nil)
		user ||= User.find(params[:id])
		render json: { users: user.following }
	end

	# GET /users/self/followed-by
	def current_user_followed_by
		followed_by(current_user)
	end

	# GET /users/user-id/followed-by
	def followed_by
		user ||= User.find(params[:id])
	end

	# GET /users/self/requested-by
	def requested_by
	end

	# GET /users/user-id/relationship
	def show
	end

	# POST /users/user-id/relationship
	def create
		action = params[:action].downcase
		actions_list = %w(follow unfollow approve ignore)
		# check if the action is within the allowable list
		if !actions_list.include?(action) 
			render json: { errors: "Bad action parameter" }, status: 422
		end
		# Respond to action
		# Find relationship based on action requested
		# Perform action and return relationship status (outgoing / incoming)
		# Create or update relationship with params
	end


	private 

		def relationship_params
			# params.require(:relationship).permit(:follower_id, :followed)
		end


end
