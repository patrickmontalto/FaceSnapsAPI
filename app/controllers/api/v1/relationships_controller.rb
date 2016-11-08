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
	def followed_by(user)
		user ||= User.find(params[:id])
    render json: { users: user.followers }
	end

	# GET /users/self/requested-by
	def requested_by
    render json: { users: current_user.requested_by }
	end

	# GET /users/user-id/relationship
	def status
    other_user = User.find(params[:id])
    outgoing_status = StatusReporter.outgoing(current_user, other_user)
    incoming_status = StatusReporter.incoming(current_user, other_user)
    render json: {data: {outgoing_status: outgoing_status, incoming_status: incoming_status} }
	end

	# POST /users/user-id/relationship
	def manage
		action = params[:user_action].downcase
    user = User.find(params[:id])
		actions_list = %w(follow unfollow approve ignore)
		# check if the action is within the allowable list
    modify_relationship(action, user)
	end


	private 

		def relationship_params
			# params.require(:relationship).permit(:follower_id, :followed)
		end

    def modify_relationship(action, user)
      case action
      when "follow"
        follow_user(user)
      when "unfollow"
        unfollow_user(user)
      when "approve"
        approve_follow_request(user)
      when "ignore"
        ignore_follow_request(user)
      else
        render json: { errors: "Bad action parameter" }, status: 422
      end
    end

    def follow_user(user)
      relationship = Relationship.find_or_create_by(follower_id: current_user.id, followed_id: user.id)
      if relationship.accepted
        render json: { data: { outgoing_status: "follows" } }, status: 200
      else
        render json: { data: { outgoing_status: "requested" } }, status: 200
      end
    end

    def unfollow_user(user)
      relationship = Relationship.find_by(follower_id: current_user.id, followed_id: user.id)
      if relationship.destroy
        render json: { data: { outgoing_status: "none" } }, status: 204
      else
        render json: { errors: "Unable to unfollow user" }, status: 422
      end
    end

    def approve_follow_request(user)
      relationship = Relationship.find_by(follower_id: user.id, followed_id: current_user.id)
      if relationship.update_attributes(accepted: true)
        render json: { data: { incoming_status: "followed_by" } }, status: 200
      else
        render json: { errors: "Unable to approve user" }, status: 422
      end
    end

    def ignore_follow_request(user)
      relationship = Relationship.find_by(follower_id: user.id, followed_id: current_user.id)
      if relationship.destroy
        render json: { data: { incoming_status: "none" } }, status: 204
      else
        render json: { errors: "Unable to ignore request" }, status: 422
      end
    end


end