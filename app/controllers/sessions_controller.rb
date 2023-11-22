class SessionsController < ApplicationController
  before_action :set_auth_params

  def create
    begin
      session_service = SessionService.new(@email, @password, @auth_type, @auth_token)
      access = session_service.authenticate!
      render json: { message: 'Login successful', token: access.user_token }
    rescue SessionService::AuthenticationError => e
      render json: { error: e.message }, status: :unauthorized
    end
  end

  private

  def set_auth_params
    @email = params[:email]
    @password = params[:password]
    @auth_type = params[:auth_type]
    @auth_token = params[:auth_token]

    if (@email.blank? || @password.blank? || @auth_type.blank?) && @auth_token.blank?
      return head(:bad_request)
    end
  end
end
