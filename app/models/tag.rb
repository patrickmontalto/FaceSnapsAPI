class Tag < ActiveRecord::Base
  include ActiveModel::Serialization
  attr_accessor :tagged_posts
  
  has_many :taggings
  has_many :posts, :through => :taggings, :source => :taggable, :source_type => 'Post'
  has_many :comments, :through => :taggings, :source => :taggable, :source_type => 'Comment'
  validates :name, presence: true, :uniqueness => {:case_sensitive => false}

  def visible_posts(user)
    public_ids = User.where(private: false).pluck(:id)
    post_user_ids = public_ids | user.following_ids
    available_posts = posts.where(user_id: post_user_ids).order('created_at DESC')
    available_posts.uniq
  end

  def posts_count(user)
    visible_posts(user).count
  end

  # Search
  def self.search(query)
    Tag.where("name like ?", "%#{query}%")
  end

end