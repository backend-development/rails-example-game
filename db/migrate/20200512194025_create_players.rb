class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :color
      t.belongs_to :user
      t.belongs_to :game
      t.integer :no_of_guesses, null: false, default: 0
      t.integer :no_of_fails, null: false, default: 0

      t.timestamps
    end
    add_index :players, %i[user_id game_id], unique: true
  end
end
