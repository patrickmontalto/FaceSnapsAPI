class Api::V1::LikesController < ApplicationController
  before_action :authenticate_with_token!

  # GET /users/self/posts/liked
  def liked_posts
    user = User.find_by(params[:id])
    render json: { posts: user.liked_posts }, adapter: :json
  end

  # GET /posts/id/likes
  def liking_users
    post = Post.find_by(params[:id])
    render json: { users: post.liking_users }, adapter: :json
  end

  # POST /posts/id/likes
  def create
    post = Post.find_by(params[:id])
    if current_user.like(post)
      render json: { meta: { code: 200 }, data: nil }, status: 200
    else
      render json: { errors: "Unable to like post: nothing to like." }, status: 422
    end
  end

  # DELETE /posts/id/likes
  def destroy 
    post = Post.find_by(params[:id])
    if current_user.unlike(post)
      render json: { meta: { code: 200 }, data: nil }, status: 200
    else
      render json: { errors: "Unable to unlike post: nothing to unlike." }, status: 422
    end
  end
end
