class PostLocation < ActiveRecord::Base
	belongs_to :post
	belongs_to :location

	validates :post, :location, presence: true
	validates :post, uniqueness: true
end