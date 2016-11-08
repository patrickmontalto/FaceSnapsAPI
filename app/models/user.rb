class User < ActiveRecord::Base
	include Tokenable
	# Create an authentication token for user
	before_create :generate_auth_token!

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :auth_token, uniqueness: true
  validates :username, presence: true, uniqueness: true

  has_many :posts, dependent: :destroy
  has_many :likes
  has_many :liked_posts, :through => :likes, :source => :post

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

  # Like a post
  def like(post)
    likes.create(post: post)
  end

  # Unlike a post
  def unlike(post)
    if like = Like.find_by(user: self, post: post)
      like.destroy
    end
  end


end
