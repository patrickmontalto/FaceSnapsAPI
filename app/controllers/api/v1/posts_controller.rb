class Api::V1::PostsController < ApplicationController
  before_action :authenticate_with_token!, only: [:update, :create]
	respond_to :json

	def show
    post = Post.find_by_id(params[:id])
    if post
      render json: post, :root => "post", adapter: :json
    else
      render json: { errors: "Post not found" }, status: 422
    end
	end

  # GET /posts - all public posts
  def index
    posts = paginate Post.public, per_page: 10
    render json: posts, :root => "posts", adapter: :json
  end

  # Creating a post will look for current_user (Authorization header, auth_token)
  def create
    post = current_user.posts.build(post_params)
    if post.save
      render json: post, :root => "post", adapter: :json, status: 201, location: [:api, post]
    else
      render json: { errors: post.errors }, status: 422
    end
  end

  def update
    post = current_user.posts.find(params[:id])
    if post.update(post_params)
      render json: post, :root => "post", adapter: :json, status: 200, location: [:api, post]
    else
      render json: { errors: post.errors}, status: 422
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy
    head 204
  end

  private

    def post_params
      params.require(:post).permit(:caption, :photo)
    end

end
