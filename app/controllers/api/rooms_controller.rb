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
    p params
    current_user.update(phone_number: params[:phoneNumber])
    room = Room.find(params[:id])
    room.players << current_user
    if room.save
      p current_user
      render status: 200, json: {
        message: "Successfully updated",
        room: room
      }.to_json
    else
       render status: 500, json: {
        message: "The To-do room could not be updated.",
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

  private
  def room_params
    params.require("room").permit("name", "description")
  end
end