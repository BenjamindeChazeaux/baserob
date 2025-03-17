class AddUrlScoreToGeoScorings < ActiveRecord::Migration[7.1]
  def change
    add_column :geo_scorings, :url_score, :integer, default: 0, null: false
  end
end
