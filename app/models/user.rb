class User < ActiveRecord::Base
	include Tokenable
  include Base64encodable
  include Photoable
	# Create an authentication token for user
	before_create :generate_auth_token!

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :auth_token, uniqueness: true
  validates :username, presence: true, uniqueness: {case_sensitive: false }
  validates :full_name, presence: true

  has_many :posts, dependent: :destroy
  has_many :likes
  has_many :liked_posts, :through => :likes, :source => :post

  mount_base64_uploader :photo, PhotoUploader

  # Relationships
  has_many :active_relationships,  -> { where accepted: true },
                                   class_name: "Relationship",
                                   foreign_key: "follower_id",
                                   dependent: :destroy
  has_many :pending_active_relationships,  -> { where accepted: false },
                                   class_name: "Relationship",
                                   foreign_key: "follower_id",
                                   dependent: :destroy
  has_many :passive_relationships, -> { where accepted: true },
                                   class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy                                      
  has_many :pending_passive_relationships, -> { where accepted: false },
                                   class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  # Collection of who the user currently requesting to follow
  has_many :requesting, :through => :pending_active_relationships, :source => :followed
  # Collection of who the user is currently requested by
  has_many :requested_by, :through => :pending_passive_relationships, :source => :follower
  # Collection of who the user is currently following (active and approved)
  has_many :following, through: :active_relationships, source: :followed
  # Collection of who the user is followed by (passive and approved)
  has_many :followers, through: :passive_relationships, source: :follower
 
  # Follows a user
  def follow(other_user)
    active_relationships.create!(followed_id: other_user.id)
  end

  # Unfollows a user
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user
  def following?(other_user)
    following.include?(other_user)
  end

  # Returns whether or not the user has been requested by the other user
  def requested_by?(other_user)
    requested_by.include?(other_user)
  end

  # Returns posts in descending order
  def recent_posts
    posts.reverse_order
  end

  # Like a post
  def like(post)
    like = likes.build(post: post)
    like.valid? ? like.save : false
  end

  # Unlike a post
  def unlike(post)
    if like = Like.find_by(user: self, post: post)
      like.destroy
      true
    else
      false
    end
  end

  # Search
  def self.search(query)
    User.where("username like ? OR full_name like ?", "%#{query}%", "%#{query}%")
  end

  #  Only allow seeing like posts if the user is not private or the requesting user is a follower
  def visible_liked_posts(other_user)
    if self.followers.include?(other_user) || !self.private?
      return liked_posts
    else
      return nil
    end
  end

end
