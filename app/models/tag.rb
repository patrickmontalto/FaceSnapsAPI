class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :posts, :through => :taggings, :source => :taggable, :source_type => 'Post'
  has_many :comments, :through => :taggings, :source => :taggable, :source_type => 'Comment'
  validates :name, presence: true, uniqueness: true

  def visible_posts
    public_ids = User.where(private: false).pluck(:id)
    post_user_ids = public_ids | current_user.following_ids
    posts.where(user_id: post_user_ids).order('created_at DESC')
  end

  def posts_count
    visible_posts.count
  end

  def as_json(options = {})
    super.as_json(options).merge({:posts_count => posts_count})
  end

end