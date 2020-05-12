class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :color
      t.belongs_to :user
      t.belongs_to :game

      t.timestamps
    end
    add_index :players, %i[user_id game_id], unique: true
  end
end
