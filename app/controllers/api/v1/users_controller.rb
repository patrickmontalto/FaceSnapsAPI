class Api::V1::UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :authenticate_with_token!, only: [:update, :destroy, :self, :search]
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

  def search
    users = paginate User.search(params[:query]), per_page: 20
    render json: users, root: "users", adapter: :json
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :username, :full_name, :photo)
    end
end