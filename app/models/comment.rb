class Comment < ActiveRecord::Base
  after_commit :set_tags

  default_scope { order('created_at DESC') }
  belongs_to :post
  belongs_to :user
  validates :post, :user, :text, presence: true
  validates :text, length: { maximum: 300 }
  has_many :taggings, :as => :taggable
  has_many :tags, :through => :taggings
  

  private 

    def set_tags
      tags = TagParser.parse(text)
      for tag in tags
        Tagging.create(tag: tag, taggable: self)
      end
    end
end
