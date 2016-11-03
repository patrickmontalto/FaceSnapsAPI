class Api::V1::PostsController < ApplicationController
	respond_to :json

	def show
		respond_with Post.find(params[:id])
	end

  def index
    respond_with Post.all
  end

end
