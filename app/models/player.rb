class Player < ActiveRecord::Base
  belongs_to :room

  def self.for_oauth oauth
    oauth.get_data
    data = oauth.data

    player = find_by(oauth.provider => data[:id]) || find_or_create_by(email: data[:email]) do |u|
      u.password =  SecureRandom.hex
    end

    player.update(
      display_name: oauth.get_names.join(' '),
      email: data[:email],
      oauth.provider => data[:id]
    )

    player
  end

  def self.from_auth(params, current_user)
    p "from_auth"
    p params = params.smash.with_indifferent_access
    authorization = Authorization.find_or_initialize_by(provider: params[:provider], uid: params[:uid])
    if authorization.persisted?
      if current_user
        p "1"
        if current_user.id == authorization.player.id
          player = current_user
        else
          return false
        end
      else
        p "2"
        player = authorization.player
      end
    else
      if current_user
        p "3"
        player = current_user
      elsif params[:email].present?
        p "4"
        player = Player.find_or_initialize_by(email: params[:email])
      else
        p "5"
        player =Player.new
      end
    end
    authorization.secret = params[:secret]
    authorization.token  = params[:token]
    player.display_name = "#{params[:first_name]} #{params[:last_name]}"
    # fallback_name        = params[:name].split(" ") if params[:name]
    # fallback_first_name  = fallback_name.try(:first)
    # fallback_last_name   = fallback_name.try(:last)
    # player.first_name    ||= (params[:first_name] || fallback_first_name)
    # player.last_name     ||= (params[:last_name]  || fallback_last_name)

    # if player.image_url.blank?
    #   player.image = Image.new(name: player.full_name, remote_file_url: params[:image_url])
    # end

    # player.password = Devise.friendly_token[0,10] if player.encrypted_password.blank?

    if player.email.blank?
      player.save(validate: false)
    else
      player.save
    end
    authorization.player_id ||= player.id
    authorization.save
    p player.errors
    p player
  end


  def displayName= name
    self.display_name = name
  end
end