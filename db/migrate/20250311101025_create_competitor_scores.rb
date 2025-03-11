class CreateCompetitorScores < ActiveRecord::Migration[7.1]
  def change
    create_table :competitor_scores do |t|
      t.integer :score
      t.integer :frequency_score
      t.integer :position_score
      t.integer :link_score
      t.references :competitor, null: false, foreign_key: true
      t.references :geo_scoring, null: false, foreign_key: true

      t.timestamps
    end
  end
end

