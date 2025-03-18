namespace :geo_scoring do
  desc "Met à jour les scores des GeoScorings existants"
  task update_scores: :environment do
    puts "Démarrage de la mise à jour des scores..."

    total = GeoScoring.count
    updated = 0

    GeoScoring.find_each do |geo_scoring|
      begin
        # Les callbacks before_save s'occupent de calculer les scores
        if geo_scoring.save
          updated += 1
          print "\rProgression: #{updated}/#{total} (#{(updated.to_f/total * 100).round(2)}%)"
        else
          puts "\nErreur lors de la mise à jour du GeoScoring #{geo_scoring.id}: #{geo_scoring.errors.full_messages.join(', ')}"
        end
      rescue => e
        puts "\nErreur lors de la mise à jour du GeoScoring #{geo_scoring.id}: #{e.message}"
      end
    end

    puts "\nMise à jour terminée. #{updated} GeoScorings mis à jour."
  end

  desc "Analyse tous les mots-clés pour toutes les entreprises"
  task analyze_all: :environment do
    puts "Démarrage de l'analyse complète..."

    Company.find_each do |company|
      puts "Traitement de l'entreprise: #{company.name}"

      company.keywords.find_each do |keyword|
        puts "  Analyse du mot-clé: #{keyword.content}"
        service = GeoScoringService.new(keyword, company)
        service.call
      end
    end

    puts "Analyse complète terminée."
  end
end
