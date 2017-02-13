class Api::V1::CommentsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :authenticate_with_token!
  respond_to :json

  # GET /posts/post_id/comments
  def index
    post = Post.find_by_id(params[:post_id])
    comments = paginate post.comments, per_page: 20
    if post
      render json: comments, :root => "comments", adapter: :json
    else
      render json: { errors: "Post not found." }, status: 422
    end
  end

  # POST /posts/post_id/comments
  def create
    post = Post.find_by_id(params[:post_id])
    author = post.user
    if reject_via_privacy?(author)
      render json: { errors: "Unable to comment on post" }, status: 422
      return
    end

    comment = post.comments.build(comment_params)
    if comment.save
      render json: {meta: {code: 200}, comment: comment }, status: 200
    else
      render json: { errors: comment.errors }, status: 422
    end
  end

  # DEL /posts/post_id/comments/id
  def destroy
    post = Post.find_by_id(params[:post_id])
    comment = post.comments.find_by_id(params[:id])
    if comment.user == current_user
      comment.destroy
      render json: {meta: {code: 200} }, status: 200
    else
      render json: { errors: "Unable to destroy comment." }, status: 422
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:text).merge(user_id: current_user.id)
    end

    def reject_via_privacy?(user)
      if user == current_user || !user.private?
        return false
      elsif user.private? && user.followers.include?(current_user)
        return false
      else
        return true
      end
    end

end
