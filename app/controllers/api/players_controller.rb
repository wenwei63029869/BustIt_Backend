class Api::PlayersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :find_room

  def create
    player = @room.players.new(player_params)
    if player.save
      render status: 200, json: {
        message: "Successfully created To-do player.",
        room: @room,
        player: player
      }.to_json
    else
      render status: 422, json: {
        message: "To-do player creation failed.",
        errors: player.errors
      }.to_json
    end
  end

  private

  def player_params
    params.require("player").permit("name", "phone_number")
  end

  def find_room
    @room = Room.find(params[:room_id])
  end
end