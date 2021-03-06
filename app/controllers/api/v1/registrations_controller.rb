class Api::V1::RegistrationsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def create
    user = User.create(user_params)
    json = request.raw_post.to_json
    if user.save
      # Note: Photo must be accessed from params in order to avoid escaping characters and invalid base64 strings
      base64_image = params["photo"]
      if base64_image
        user.update_attributes(photo: base64_image)
      end
      sign_in user, store: false
      user.generate_auth_token!
      user.save
      render json: user, status: 200, location: [:api, user]
    else
      errors = user.errors.messages
      render json: { errors: errors.each { |key, arr| errors[key] = arr[0] } }, status: 400
    end
  end

  def check_availability
    user_credential = params[:user_credential].downcase
    user = User.find_by(email: user_credential) || User.find_by(username: user_credential)

    if user_credential.length < 3
      render json: { available: false }
    elsif user.nil? 
      render json: { available: true }
    else
      render json: { available: false }
    end
  end

  private 

    def user_params
      params.require(:user).permit(:username, :full_name, :email, :password, :photo)
    end
end