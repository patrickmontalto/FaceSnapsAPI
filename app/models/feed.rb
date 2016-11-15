class Feed
  include ActiveModel::Model

  def initialize(user)
    @user = user
  end

  def posts
    Post.where(user_id: post_user_ids).order('created_at DESC')
  end

  private

     def post_user_ids
      [@user.id] + @user.following_ids
     end
end