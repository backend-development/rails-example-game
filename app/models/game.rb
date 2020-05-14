class Game < ApplicationRecord
  has_many :players

  scope :available, -> { where(game_state: 'lobby') }
  scope :running, -> { where(game_state: %w[waiting_for_white waiting_for_black]) }
  scope :over, -> { where(game_state: %w[white_won black_won]) }

  include AASM

  aasm column: :game_state do
    state :lobby, initial: true

    state :waiting_for_black
    state :waiting_for_white

    event :next_player do
      transitions from: :waiting_for_black, to: :waiting_for_white
      transitions from: :waiting_for_white, to: :waiting_for_black
    end

    event :won do
      transitions from: :waiting_for_black, to: :black_won
      transitions from: :waiting_for_white, to: :white_won
    end

    state :black_won
    state :white_won
  end

  def over?
    black_won? || white_won?
  end

  def self.start(user:)
    word = Vocabulary.random
    g = Game.create(word: word, mask: word.gsub(/./, '_'))
    g.players.create(color: 'white', user: user)
    g
  end

  def join(user_black)
    players.create!(color: 'black', user: user_black)
    update(game_state: 'waiting_for_black')
    save!
  end

  def guess(letter)
    current_player.inc_guesses
    if word.include?(letter)
      (0...word.length).each do |i|
        mask[i] = letter if word[i] == letter
      end

      if word == mask
        update(closed_at: DateTime.now)
        won
      end
      # do not change state, player can go again!
    else
      current_player.inc_fails
      next_player
    end
    save
  end

  def player?(user)
    players.where(user_id: user.id).count.positive?
  end

  def winner?(user)
    white_player.user_id == user.id  if game_state == 'white_won'
    black_player.user_id == user.id  if game_state == 'black_won'
    false
  end

  def white_player
    players.find_by(color: 'white')
  end

  def black_player
    players.find_by(color: 'black')
  end

  def current_player
    return black_player if waiting_for_black?
    return white_player if waiting_for_white?

    nil
  end
end
