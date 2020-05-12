class CreateVocabulary < ActiveRecord::Migration[6.0]
  def change
    create_table :vocabulary do |t|
      t.string :word

      t.timestamps
    end
  end
end
