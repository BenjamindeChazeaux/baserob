class AddFieldsToGeoScorings < ActiveRecord::Migration[7.0]
  def change
    add_column :geo_scorings, :reference_score, :float
    add_column :geo_scorings, :url_presence, :boolean
    add_column :geo_scorings, :url_value, :string
  end
end
