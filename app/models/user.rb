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
end
