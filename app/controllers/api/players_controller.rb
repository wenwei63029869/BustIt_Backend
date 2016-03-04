class Api::PlayersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :find_room

  def create
    player = @room.players.new(player_params)
    if player.save
      render status: 200, json: {
        message: "Successfully created player.",
        room: @room,
        player: player
      }.to_json
    else
      render status: 422, json: {
        message: "player creation failed.",
        errors: player.errors
      }.to_json
    end
  end

  def update
    player = current_user
      if player.update(player_params)
        render status: 200, json: {
          message: "Successfully updated player.",
          room: @room,
          player: player
        }.to_json
      else
        render status: 422, json: {
          message: "player update failed.",
          errors: player.errors
        }.to_json
      end
  end

  def destroy
    player = @room.players.find(params[:id])
    player.destroy
    render status: 200, json: {
      message: "player successfully deleted.",
      room: @room,
      player: player
    }.to_json
  end

  private

  def player_params
    params.require("player").permit("displayName", "phone_number")
  end

  def find_room
    @room = Room.find(params[:room_id])
  end

end