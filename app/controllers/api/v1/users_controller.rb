class Api::V1::UsersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!, only: [:update, :destroy]
  def show
    respond_with User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    @user.generate_authentication_token!
    if @user.save
      render json: @user, status: 201
    else
      render json: { errors: @user.errors, status: 422 }
    end
  end

  def update
    user = current_user
    if user.update(user_params)
      render json: user, status: 200
    else
      render json: { errors: user.errors, status: 422 }
    end
  end

  def destroy
    current_user.destroy
    render json: { massage: "Successfully deleted!", id: params[:id], status: 204 }
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
