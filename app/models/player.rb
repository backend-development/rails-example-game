class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game

  def inc_guesses
    update(no_of_guesses: 1 + no_of_guesses)
  end

  def inc_fails
    update(no_of_fails: 1 + no_of_fails)
  end
end
