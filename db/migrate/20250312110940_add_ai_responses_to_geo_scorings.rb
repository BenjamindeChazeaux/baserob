class AddAiResponsesToGeoScorings < ActiveRecord::Migration[7.1]
  def change
    add_column :geo_scorings, :ai_responses, :json, default: []
  end
end
