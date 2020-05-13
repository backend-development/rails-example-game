class GamesController < ApplicationController
  before_action :set_game, only: %i[show edit update destroy]

  # GET /games
  # GET /games.json
  def index
    @available_games = Game.available
    @running_games = Game.running
    @over_games = Game.over
  end

  # GET /games/1
  # GET /games/1.json
  def show; end

  def create
    if current_user
      g = Game.start(user: current_user)
      redirect_to game_path(g)
    else
      redirect_to root_path
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.includes(:players).find(params[:id])
  end
end
