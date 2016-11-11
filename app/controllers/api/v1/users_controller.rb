class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:update, :destroy, :self]
  respond_to :json

  def self
    render json: current_user, root: "user", adapter: :json, status: 200
  end

  def show
    user = User.find_by_id(params[:id])
    if user
      render json: user, root: "user", adapter: :json
    else
      render json: { errors: "User not found" }, status: 422
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, root: "user", adapter: :json, status: 201, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    user = current_user

    if user.update(user_params)
      render json: user, root: "user", adapter: :json, status: 200, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    current_user.destroy
    head 204
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :username)
    end

end