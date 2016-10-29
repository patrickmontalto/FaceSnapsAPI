module Tokenable
	extend ActiveSupport::Concern
	
	# Generate auth token for user
	def generate_auth_token!
  	begin
  		self.auth_token = Devise.friendly_token
  	end while User.exists?(auth_token: auth_token)
	end
end