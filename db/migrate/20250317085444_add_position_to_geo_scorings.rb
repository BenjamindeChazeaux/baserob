class AddPositionToGeoScorings < ActiveRecord::Migration[7.1]
  def change
    add_column :geo_scorings, :position, :integer
  end
end
