class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :game_state
      t.string :word
      t.string :mask
      t.timestamp :closed_at
      t.timestamps
    end
  end
end
