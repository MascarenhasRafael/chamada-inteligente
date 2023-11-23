class SessionsController < ApplicationController
  before_action :set_auth_params

  def create
    begin
      session_service = SessionService.new(@email, @password, @auth_type, @auth_token)
      access = session_service.authenticate!

      cookies[:auth_token] = {
        value: access.user_token,
        expires: 30.minutes.from_now,
      }

      render json: { message: 'Login successful', token: access.user_token }
    rescue SessionService::AuthenticationError => e
      cookies.delete(:auth_token) if cookies[:auth_token].present?
      render json: { error: e.message }, status: :unauthorized
    end
  end

  def destroy
    return head(:bad_request) unless @auth_token

    access = Access.find_by(user_token: @auth_token)
    return head(:unprocessable_entity) unless access&.destroy

    cookies.delete(:auth_token)
    render json: { message: 'Logout successful' }
  end

  private

  def set_auth_params
    @email = params[:email]
    @password = params[:password]
    @auth_type = params[:auth_type]
    @auth_token = cookies[:auth_token] || nil

    if (@email.blank? || @password.blank? || @auth_type.blank?) && @auth_token.blank?
      return head(:bad_request)
    end
  end
end
