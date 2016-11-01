class Post < ActiveRecord::Base
  def tags
    caption.scan(/\B#\w+/).map { |t| t[1..-1].downcase }
  end
end
