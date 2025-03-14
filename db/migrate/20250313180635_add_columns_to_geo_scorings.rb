class AddColumnsToGeoScorings < ActiveRecord::Migration[7.1]
  def change
    add_column :geo_scorings, :url_presence, :boolean
    add_column :geo_scorings, :url_value, :string
    add_column :geo_scorings, :reference_score, :integer
  end
end
