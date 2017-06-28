class Api::V1::SessionsController < ApplicationController

  def create
    @resource = User.find_for_database_authentication(:email => params[:user][:email])
    if @resource.valid_password?(params[:user][:password])
      sign_in @resource, store: true
      @resource.generate_authentication_token!
      @resource.save
      render json: { status: 200, auth_token: @resource[:auth_token] }
    else
      render json: { status: 422, errors: "Invalid email or password" }
    end
  end

  def destroy
    @resource = User.find_by(auth_token: params[:id])
    if @resource
      @resource.invalidate_auth_token
      @resource.save
      render json: { massage: "Successfully session destroyed!", status: 204 }
    else
      render json: { status: 400, errors: "Invalid auth_token" }
    end
  end

end
