class AddUrlToGeoScorings < ActiveRecord::Migration[7.1]
  def change
    add_column :geo_scorings, :url, :string
  end
end
