class Api::V1::PostsController < ApplicationController
	respond_to :json

	def show
		respond_with Post.find(params[:id])
	end

  def index
    respond_with Post.all
  end

  def create
    post = current_user.posts.build(post_params)
    if post.save
      render json: post, status: 201, location: [:api, post]
    else
      render json: { errors: post.errors }, status: 422
    end
  end

  private

    def post_params
      params.require(:post).permit(:caption, :photo)
    end

end
