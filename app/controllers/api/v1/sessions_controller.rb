class Api::V1::SessionsController < ApplicationController
	# Sign in
  def create
    user_password = params[:session][:password]
    user_credential = params[:session][:credential]
    user = User.find_by(email: user_credential) || User.find_by(username: user_credential)

    if user.nil?
      render json: { errors: { title: "Incorrect username", 
                              message: "The username you entered doesn't appear to belong to an account. 
                                        Please check your username and try again." } }
    elsif user.valid_password? user_password
      sign_in user, store: false
      user.generate_auth_token!
      user.save
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: {title: "Incorrect password for #{user_credential}", message: "The password you entered is incorrect. Please try again." } }, status: 422
    end
  end

  # Sign out - find user by token and create a new one (invalidate old token)
  def destroy
  	user = User.find_by(auth_token: params[:id])
  	user.generate_auth_token!
  	user.save
  	head 204
  end
end