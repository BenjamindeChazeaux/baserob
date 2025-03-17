class CreateGeoScorings < ActiveRecord::Migration[7.1]
  def change
    create_table :geo_scorings do |t|
      t.integer :score
      t.boolean :mentioned, default: false
      #Ex:- :default =>''
      t.integer :position
      t.string :url
      t.text :ai_responses, array: true, default: []
      t.references :keyword, null: false, foreign_key: true
      t.references :ai_provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
