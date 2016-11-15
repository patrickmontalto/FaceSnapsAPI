class Api::V1::FeedController < ApplicationController
  before_action :authenticate_with_token!

  # GET /users/self/feed
  def show
    feed = Feed.new(current_user)
    posts = paginate feed.posts, per_page: 10
    render json: posts, :root => "posts", adapter: :json
  end

end
