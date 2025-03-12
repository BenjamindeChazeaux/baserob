class CreateJoinTableGeoScoringsAiProviders < ActiveRecord::Migration[7.1]
  def change
    create_join_table :geo_scorings, :ai_providers do |t|
      # t.index [:geo_scoring_id, :ai_provider_id]
      # t.index [:ai_provider_id, :geo_scoring_id]
    end
  end
end
