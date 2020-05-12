json.extract! game, :id, :game_state, :word, :closed_at, :black, :white, :created_at, :updated_at
json.url game_url(game, format: :json)
