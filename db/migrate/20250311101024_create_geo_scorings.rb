class CreateGeoScorings < ActiveRecord::Migration[7.1]
  def change
    create_table :geo_scorings do |t|
      t.integer :score
      t.integer :frequency_score
      t.integer :position_score
      t.integer :link_score
      t.references :keyword, null: false, foreign_key: true
      t.references :ai_provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
