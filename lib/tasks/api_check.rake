namespace :api do
  desc "Vérifier la connexion avec les APIs pour les mots-clés"
  task check: :environment do
    puts "=== Vérification des connexions API ==="
    puts "Vérification des API d'IA (OpenAI, Anthropic, Perplexity)..."

    # Mot-clé de test simple
    test_prompt = "Meilleure formation en intelligence artificielle en ligne"

    # Résultats de test pour chaque fournisseur
    results = []

    # Vérifier chaque API supportée
    AiProvider::SERVICES.each do |provider_name|
      print "Vérification de #{provider_name}... "

      provider = AiProvider.find_by(name: provider_name)
      if provider.nil?
        results << {
          name: provider_name,
          status: :error,
          error: "Fournisseur non trouvé dans la base de données"
        }
        puts "❌ ÉCHEC (fournisseur non trouvé)"
        next
      end

      start_time = Time.now
      begin
        # Tente d'analyser le mot-clé avec ce fournisseur
        response = provider.analyze(test_prompt)
        duration = (Time.now - start_time).round(2)

        # Vérifie si la réponse est valide (un tableau avec des éléments)
        if response.is_a?(Array) && response.any?
          results << {
            name: provider_name,
            status: :success,
            items_count: response.size,
            duration: duration,
            sample: response.first
          }
          puts "✅ OK (#{response.size} éléments en #{duration}s)"
        else
          results << {
            name: provider_name,
            status: :warning,
            error: "Réponse vide ou invalide",
            response: response.inspect,
            duration: duration
          }
          puts "⚠️ AVERTISSEMENT (réponse vide ou invalide en #{duration}s)"
        end
      rescue => e
        duration = (Time.now - start_time).round(2)
        results << {
          name: provider_name,
          status: :error,
          error: "#{e.class.name}: #{e.message}",
          duration: duration
        }
        puts "❌ ÉCHEC (erreur en #{duration}s)"
        puts "   #{e.class.name}: #{e.message}"
      end
    end

    # Affiche un résumé
    puts "\n=== Résumé ==="
    success_count = results.count { |r| r[:status] == :success }
    warning_count = results.count { |r| r[:status] == :warning }
    error_count = results.count { |r| r[:status] == :error }

    puts "#{success_count}/#{results.size} API fonctionnelles"
    puts "#{warning_count} avertissements" if warning_count > 0
    puts "#{error_count} erreurs" if error_count > 0

    if success_count == results.size
      puts "\n✅ Toutes les API sont fonctionnelles!"
    else
      puts "\n⚠️ Certaines API présentent des problèmes."
    end

    # Affiche les détails pour les erreurs et avertissements
    if warning_count > 0 || error_count > 0
      puts "\n=== Détails des problèmes ==="

      results.each do |result|
        next if result[:status] == :success

        puts "- #{result[:name]}: #{result[:status] == :warning ? 'AVERTISSEMENT' : 'ERREUR'}"
        puts "  #{result[:error]}"
        puts "  Réponse reçue: #{result[:response]}" if result[:response]
        puts "  Durée: #{result[:duration]}s"
        puts ""
      end
    end

    # Affiche des exemples de résultats pour les succès
    puts "\n=== Exemples de réponses (succès) ==="
    results.select { |r| r[:status] == :success }.each do |result|
      puts "- #{result[:name]} (#{result[:items_count]} éléments, #{result[:duration]}s):"
      puts "  #{result[:sample]}"
    end
  end
end
