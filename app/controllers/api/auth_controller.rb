class Api::AuthController < ApplicationController

  skip_before_action :verify_authenticity_token, only: :authenticate

  def render_data(data, status)
    p "callback"
    p params[:callback]
    render json: data, status: status, callback: params[:callback]
  end

  def render_error(message, status = :unprocessable_entity)
    render_data({ error: message }, status)
  end

  def render_success(data, status = :ok)
    if data.is_a? String
      p "data"
      p data
      render_data({ message: data }, status)
    else
      p "data"
      p data
      render_data(data, status)
    end
  end

  def authenticate

    p "*" * 50
    @oauth = "Oauth::#{params['provider'].titleize}".constantize.new(params)
    p @oauth
    p "*" * 50

    if @oauth.authorized?
      p "proceed"
      @player = Player.from_auth(@oauth.formatted_user_data, current_user)
      if @player
        render_success(token: Token.encode(@player.id), id: @player.id)
      else
        render_error "This #{params[:provider]} account is used already"
      end
    else
      render_error("There was an error with #{params['provider']}. please try again.")
    end
  end

  def show
    p "get current_user"
    p current_user
    render json: current_user
  end

end