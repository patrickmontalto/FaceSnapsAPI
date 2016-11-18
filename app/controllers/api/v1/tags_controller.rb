class Api::V1::TagsController < ApplicationController
  before_action :authenticate_with_token!, only: [:show, :posts, :search]
  
  # GET /tags/tag-name
  def show
    tag = Tag.find_by(name: params[:tag_name])
    count = tag.posts_count(current_user)
    render json: { data: { post_count: count, name: tag.name }}, adapter: :json
  end

  # GET tags/tag-name/posts/recent
  def posts
    tag = Tag.find_by(name: params[:tag_name])
    posts = paginate tag.visible_posts(current_user), per_page: 20

    render json: posts, root: "posts", adapter: :json
  end

  # GET /tags/search
   def search
    tags = paginate Tag.search(params[:query]), per_page: 20
    for tag in tags do
      tag.tagged_posts = tag.posts_count(current_user)
    end
    render json: tags, root: "tags"
  end

end
