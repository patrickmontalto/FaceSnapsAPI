class Post < ActiveRecord::Base
	belongs_to :user
	validates :caption, :user_id, :photo, presence: true
	mount_base64_uploader :photo, PhotoUploader

  def tags
    caption.scan(/\B#\w+/).map { |t| t[1..-1].downcase }
  end

  def as_json(options = {})
    super.as_json(options).merge({:tags => tags})
  end
end
