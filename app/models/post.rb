class Post < ActiveRecord::Base
  include Base64encodable
  after_commit :set_tags

	belongs_to :user
  has_many :likes
  has_many :comments
  has_many :liking_users, :through => :likes, :source => :user
  has_many :taggings, :as => :taggable
  has_many :tags, :through => :taggings
  has_one :post_location
  has_one :location, :through => :post_location

	validates :caption, :user_id, :photo, presence: true
	mount_base64_uploader :photo, PhotoUploader

  # Public posts (author is not private)
  def self.public
    joins(:user).where(:users => {:private => false })
  end

  def save_with_location(location)
    save!
    set_location(location)
  end

  def as_json(options = {})
    super.as_json(options).merge({:tags => tags})
  end

  def like_count
    likes.count
  end

  private 

    def set_tags
      tags = TagParser.parse(caption)
      for tag in tags
        Tagging.create(tag: tag, taggable: self)
      end
    end

    def set_location(location)
      loc = Location.find_by(venue_id: location[:id])
      if !loc
        loc = Location.create( venue_id: location[:id],
                               latitude: location[:lat],
                               longitude: location[:lng],
                               name: location[:name])
      end
      self.location = loc
    end
end
