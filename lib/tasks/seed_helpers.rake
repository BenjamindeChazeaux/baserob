namespace :seed do
  desc "Tester la connexion API pour un mot-clé spécifique"
  task :test_keyword, [:keyword] => :environment do |t, args|
    if args[:keyword].blank?
      puts "Erreur: Veuillez spécifier un mot-clé à tester."
      puts "Exemple: rake seed:test_keyword[\"formation en intelligence artificielle\"]"
      exit 1
    end

    keyword_content = args[:keyword]
    puts "=== Test des API avec le mot-clé: \"#{keyword_content}\" ==="

    AiProvider.all.each do |provider|
      puts "\n* Fournisseur: #{provider.name.upcase}"

      begin
        start_time = Time.now
        response = provider.analyze(keyword_content)
        duration = (Time.now - start_time).round(2)

        if response.is_a?(Array) && response.any?
          puts "✅ Succès (#{duration}s, #{response.size} éléments)"
          puts "Réponses:"
          response.each_with_index do |item, index|
            puts "  #{index+1}. #{item}"
          end
        else
          puts "⚠️ Avertissement: Réponse vide ou invalide (#{duration}s)"
          puts "Réponse brute: #{response.inspect}"
        end
      rescue => e
        puts "❌ Erreur: #{e.class.name} - #{e.message}"
      end
    end
  end

  desc "Vérifier que tous les fournisseurs d'IA sont disponibles dans la base de données"
  task check_providers: :environment do
    puts "=== Vérification des fournisseurs d'IA ==="

    missing_providers = []

    AiProvider::SERVICES.each do |provider_name|
      provider = AiProvider.find_by(name: provider_name)
      if provider
        puts "✅ #{provider_name}: OK"
      else
        puts "❌ #{provider_name}: MANQUANT"
        missing_providers << provider_name
      end
    end

    if missing_providers.any?
      puts "\n🔧 Création des fournisseurs manquants..."
      missing_providers.each do |provider_name|
        AiProvider.create!(name: provider_name)
        puts "  ✓ #{provider_name} créé"
      end
      puts "\n✅ Tous les fournisseurs sont maintenant disponibles."
    else
      puts "\n✅ Tous les fournisseurs sont disponibles."
    end
  end
end
