class Post < ActiveRecord::Base
	validates :caption, :user_id, :photo, presence: true
  def tags
    caption.scan(/\B#\w+/).map { |t| t[1..-1].downcase }
  end
end
