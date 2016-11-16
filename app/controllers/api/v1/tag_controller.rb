class Api::V1::TagController < ApplicationController

  # GET /tags/tag-name
  def show
    tag = Tag.find_by(name: params[:tag_name])
    render json: tag, root: "tag", adapter: :json
  end

  # GET tags/tag-name/posts/recent
  def posts
    tag = Tag.find_by(name: params[:tag_name])
    posts = paginate tag.visible_posts, per_page: 10

    render json: posts, root: "posts", adapter: :json
  end

  # GET /tags/search
   def search
    tags = paginate Tag.search(params[:query]), per_page: 20
    render json: tags, root: "tags", adapter: :json
  end

end
