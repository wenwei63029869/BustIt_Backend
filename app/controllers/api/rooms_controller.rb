class Api::RoomsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def index
    rooms = Room.all
    render json: rooms.as_json(include:[:players])
  end

  def show
    room = Room.find(params[:id])
    render json: room.as_json(include:[:players])
  end

  def create
    room = Room.new(room_params)
    if room.save
      render status: 200, json: {
        message: "Successfully created a room",
        room: room
      }.to_json
    else
      render status: 422, json: {
        errors: room.errors.messages
      }.to_json
    end
  end

  def update
    p "*" * 50
    p params
    room = Room.find(params[:id])
    if params["exit"]
      current_user.update(room_id: nil)
    else
      user = current_user
      user.update(phone_number: params[:phoneNumber], role: params[:role])
      room.players << user unless room.players.include?(user)
    end
    if room.save
      p 'save'
      render status: 200, json: {
        message: "Successfully updated",
        room: room
      }.to_json(include:[:players])
    else
      render status: 500, json: {
        message: "The room could not be updated.",
        room: room
      }.to_json
    end
  end

  def destroy
    room = Room.find(params[:id])
    room.destroy
    render json: {
        status: 200,
        message: "Successfully deleted a room",
        room: room
      }.to_json
  end

  def game_begin
    # account_sid = 'Axxxxx'
    # auth_token = 'axxxxxx'

    # @client = Twilio::REST::Client.new account_sid, auth_token

    # @client.account.messages.create(
    #   from: '+16262437716',
    #   to: '+1xxxxx',
    #   body: 'Honey, I am your best friend.'
    # )

    p params[:keyword_pair]
    room = Room.find(params[:id])
    players = room.players.where(role: 'player')
    p "keyword pair"
    p keyword_pair = if params[:keyword_pair]
      keyword = Keyword.new(keyword_one: params[:keyword_pair][:keyword_one], keyword_two: params[:keyword_pair][:keyword_two])
      keyword.save
      {"spy_keyword" => params[:keyword_pair][:keyword_one], "citizen_keyword" => params[:keyword_pair][:keyword_two]}
    else
      keyword_generater
    end
    spy_citizen_generater(keyword_pair, players)
    room.update(status: 'in progress')
    render json: room.as_json(include:[:players])
  end

  def vote_out
    p params
    p room = Room.find(params[:id])
    p player = Player.find(params[:player_id])
    if player.role == 'spy'
      room.update(status: nil)
      room.players.each do |user|
        user.update(role: 'player', keyword: 'keyword') if user.role != 'judge'
      end
      render json: {game_over: true, message: "Game over", room: room}.to_json(include:[:players])
    else
      player.update(role: 'audience')
      render json: {game_over: false, message: "Game continues", room: room}.to_json(include:[:players])
    end
  end

  private
  def room_params
    params.require("room").permit("name", "description")
  end

  def keyword_generater
    index = rand(1..Keyword.all.count)
    keywords = Keyword.find(index)
    keyword_pair = [keywords.keyword_one, keywords.keyword_two]
    spy_keyword_index = rand(0..1)
    spy_keyword = keyword_pair.delete_at(spy_keyword_index)
    {"spy_keyword" => spy_keyword, "citizen_keyword" => keyword_pair[0]}
  end

  def spy_citizen_generater(keyword_pair, players)
    players_array = players.to_a
    spy_player_index = rand(0...players.length)
    spy_player = players_array.delete_at(spy_player_index)
    spy_player.update(keyword: keyword_pair["spy_keyword"], role: 'spy')
    players_array.each do |player|
      player.update(keyword: keyword_pair["citizen_keyword"], role: 'citizen')
      p player.keyword
    end
  end
end