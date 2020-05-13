class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_for game
    if current_user.present? then
      Rails.logger.warn("user #{current_user} subscribed GameChannel #{game.id} ")
      broadcast_state
    else
      Rails.logger.warn("a guest has subscribed to GameChannesl #{game.id}")
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    if data['command'] == 'join'
      game.join(current_user)
      broadcast_state
    end
    if data['guess'].present? && current_user.id == game.current_player.user_id then
      game.guess(data['guess'])
      broadcast_state
    end
  end

  def game
    Game.find(params[:game_id])
  end

  def broadcast_state
    board = ApplicationController.render( partial: 'games/game', locals: {game: game, current_user: current_user })
    GameChannel.broadcast_to game, board: board, game_state: game.game_state
  end
end
