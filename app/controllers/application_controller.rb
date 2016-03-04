class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    p set_current_user
  end

  private

  def authenticate_user!
    unauthorized! unless current_user
  end

  def unauthorized!
    head :unauthorized
  end

  def current_userserializers
    @current_user
  end

  def set_current_user
    token = request.headers['Authorization'].to_s.split(' ').last
    return unless token

    payload = Token.new(token)

    @current_user = Player.find(payload.user_id) if payload.valid?
  end
end
