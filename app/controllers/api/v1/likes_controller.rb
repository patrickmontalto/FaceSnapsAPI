class Api::V1::LikesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :authenticate_with_token!
  respond_to :json

  # GET /users/self/posts/liked
  def liked_posts
    posts = paginate current_user.liked_posts, per_page: 20
    posts_json = ActiveModel::ArraySerializer.new(posts, each_serializer: PostSerializer, scope: view_context)
    render json: { posts: posts_json }, adapter: :json
  end

  # GET /posts/id/likes
  def liking_users
    post = Post.find(params[:id])
    users_json = ActiveModel::ArraySerializer.new(post.liking_users, each_serializer: UserSerializer, scope: view_context)
    render json: { users: users_json }, adapter: :json
  end

  # POST /posts/id/likes
  def create
    post = Post.find(params[:id])
    if current_user.like(post)
      render json: { meta: { code: 200 }, data: nil }, status: 200
    else
      render json: { errors: "Unable to like post: nothing to like." }, status: 422
    end
  end

  # DELETE /posts/id/likes
  def destroy 
    post = Post.find(params[:id])
    if current_user.unlike(post)
      render json: { meta: { code: 200 }, data: nil }, status: 200
    else
      render json: { errors: "Unable to unlike post: nothing to unlike." }, status: 422
    end
  end
end
