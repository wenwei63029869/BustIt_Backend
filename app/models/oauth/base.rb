module Oauth
  class Base
    attr_reader :provider, :data, :access_token, :uid

    def initialize params
      p "initialize"
      p @provider = self.class.name.split('::').last.downcase
      prepare_params params
      puts "PARAMS - #{@params}"
      @client = HTTPClient.new
      @access_token = params[:access_token].presence || get_access_token
      puts "ACCESS TOKEN IS - #{@access_token}"
      get_data if @access_token.present?
    end

    def get_access_token
      p "get_access_token"

      response = @client.post(self.class::ACCESS_TOKEN_URL, @params)
      puts "ACCESS TOKEN RESPONSE - #{response.body}"
      JSON.parse(response.body)["access_token"]
    end

    def prepare_params params
      p "prepare_params"

      p @params = {
        code:          params[:code],
        redirect_uri:  params[:redirectUri],
        client_id:     "1763699113853883",
        # client_id:     ENV["#{@provider.upcase}_KEY"],
        client_secret: "d1aecbd517f1bdb466e259497b7016bf",
        # client_secret: ENV["#{@provider.upcase}_SECRET"],
        grant_type:    'authorization_code'
      }
    end

    def authorized?
      p "authorized?"
      p @access_token.present?

    end

  end

end