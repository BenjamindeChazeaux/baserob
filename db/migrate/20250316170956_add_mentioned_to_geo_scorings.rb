class AddMentionedToGeoScorings < ActiveRecord::Migration[7.1]
  def change
    add_column :geo_scorings, :mentioned, :boolean, default: false
  end
end
