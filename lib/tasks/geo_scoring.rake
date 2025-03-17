namespace :geo_scoring do
  desc "Met à jour les scores des GeoScorings existants"
  task update_scores: :environment do
    puts "Démarrage de la mise à jour des scores..."

    total = GeoScoring.count
    updated = 0

    GeoScoring.find_each do |geo_scoring|
      begin
        # Recalculer la position et la mention
        geo_scoring.calculate_position

        # Recalculer le score
        geo_scoring.calculate_score

        # Sauvegarder les changements
        geo_scoring.save!

        updated += 1
        print "\rProgression: #{updated}/#{total} (#{(updated.to_f/total * 100).round(2)}%)"
      rescue => e
        puts "\nErreur lors de la mise à jour du GeoScoring #{geo_scoring.id}: #{e.message}"
      end
    end

    puts "\nMise à jour terminée. #{updated} GeoScorings mis à jour."
  end
end
