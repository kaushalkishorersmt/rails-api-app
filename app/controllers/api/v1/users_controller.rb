class Api::V1::UsersController < ApplicationController
  respond_to :json

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
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user, status: 200
    else
      render json: { errors: user.errors, status: 422 }
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    render json: { massage: "Successfully deleted!", id: params[:id], status: 204 }
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
