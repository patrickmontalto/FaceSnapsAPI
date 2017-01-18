module Photoable
	extend ActiveSupport::Concern
	
	# Photo path
	def photo_path
  	if self.photo
      self.photo.url
    end
  end
end