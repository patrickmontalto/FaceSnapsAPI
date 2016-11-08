class Relationship < ActiveRecord::Base
  before_create :respond_to_user_privacy

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true

  private

    def respond_to_user_privacy
      followed_user = User.find(followed_id)
      self.accepted = !followed_user.private?
      return true
    end
end
