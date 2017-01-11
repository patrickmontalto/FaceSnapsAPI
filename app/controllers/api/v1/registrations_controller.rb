class Api::V1::RegistrationsController < ApplicationController
  respond_to :json

  def create
    user = User.create(user_params)
    if user.save
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
      params.require(:user).permit(:username, :full_name, :email, :password)
    end
end