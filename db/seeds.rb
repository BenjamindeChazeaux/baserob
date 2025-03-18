CompanyAiProvider.destroy_all
CompetitorScore.destroy_all
GeoScoring.destroy_all
Competitor.destroy_all
Request.destroy_all
Keyword.destroy_all
AiProvider.destroy_all
User.destroy_all
Company.destroy_all
puts "===> Seed destroyed"

# Vérification et initialisation des fournisseurs d'IA
puts "Vérification des fournisseurs d'IA..."
AiProvider::SERVICES.each do |provider_name|
  provider = AiProvider.find_or_create_by(name: provider_name)
  puts "  - #{provider_name}: #{provider.new_record? ? 'créé' : 'existant'}"
end
puts "Les fournisseurs d'IA sont prêts.\n\n"

# Vérifie la connexion aux API si l'option est activée
if ENV['TEST_API_CONNECTIONS'] == 'true'
  puts "Vérification des connexions API..."
  test_keyword = "Meilleure formation en intelligence artificielle en ligne"

  AiProvider.all.each do |provider|
    print "  - Test de #{provider.name}... "
    begin
      response = provider.analyze(test_keyword)
      if response.is_a?(Array) && response.any?
        puts "OK (#{response.size} réponses)"
      else
        puts "ATTENTION (réponse vide ou invalide)"
      end
    rescue => e
      puts "ÉCHEC (#{e.message})"
    end
  end
  puts "\n"
end

# Création des entreprises
companies = Company.create!([
  { name: "Le Wagon Bar", domain: "https://www.lewagon.com", token: 'c52cf53345ce51d8e20ad727386e239a' },
  { name: "Airbnb", domain: "https://www.airbnb.com" },
  { name: "Uber", domain: "https://www.uber.com" },
  { name: "Spotify", domain: "https://www.spotify.com" },
  { name: "GitHub", domain: "https://www.github.com" }
])
puts "===> Company created"

company = Company.first

# Création des utilisateurs
users = User.create!([
  { email: "ben@gmail.com", password: "password1", company: company },
  { email: "anh@gmail.com", password: "password2", company: company },
  { email: "antoine@gmail.com", password: "password3", company: company },
  { email: "yannick@gmail.com", password: "password4", company: company },
  { email: "test@test.com", password: "azerty", company: company }
])
puts "===> Users created"

# Création des AI Providers
ai_providers = AiProvider.create!([
  { name: "openai" },
  { name: "anthropic" },
  { name: "perplexity" }
])
puts "===> AI Providers created"

# Association des AI Providers à l'entreprise
ai_providers.each do |provider|
  CompanyAiProvider.create!(company: company, ai_provider: provider)
end
puts "===> AI Providers linked to company"

# Création des requêtes sur 3 jours
end_time = Time.now - 10.minutes
(Date.new(2024, 9, 1)..end_time.to_date).each do |date|
  max_hour = date == end_time.to_date ? end_time.hour : 23
  ["https://www.chatgpt.com", "http://www.claude.ai", "http://www.perplexity.ai"].each do |referrer|
    rand(5..15).times do |i|
      created_time = date.to_time + rand(max_hour + 1).hours

      next if created_time > end_time

      Request.create!(
        domain: ["https://www.lewagon.com", "https://www.airbnb.com", "https://www.uber.com", "https://www.github.com"].sample,
        path: ["/learn", "/repos"],
        user_agent: "Mozilla/5.0",
        company: company,
        created_at: created_time,
        referrer: referrer
      )
      puts "===> request n°#{Request.count} created"
    end
  end
end
puts "===> requests created"


# Création des mots-clés
keywords = Keyword.create!([
  { content: "Meilleure formation en intelligence artificielle en ligne", company: company },
  { content: "Meilleur bootcamp de Machine Learning ?", company: company },
  { content: "Top écoles pour apprendre la Data Science", company: company }
])
puts "===> Keywords created"

# Crearion des requêtes sur 3 jours
end_time = Time.now - 10.minutes
(Date.new(2024, 9, 1)..end_time.to_date).each do |date|
  max_hour = date == end_time.to_date ? end_time.hour : 23
  ["https://www.chatgpt.com", "http://www.claude.ai", "http://www.perplexity.ai"].each do |referrer|
    rand(5..15).times do |i|
      created_time = date.to_time + rand(max_hour + 1).hours

      next if created_time > end_time

      Request.create!(
        domain: ["https://www.lewagon.com", "https://www.airbnb.com", "https://www.uber.com", "https://www.github.com"].sample,
        path: ["/learn", "/repos"].sample,
        user_agent: "Mozilla/5.0",
        company: company,
        created_at: created_time,
        referrer: referrer
      )
      puts "===> Request n°#{Request.count} created"
    end
  end
end
puts "===> Requests created"

# creation de scores sur 3 jours pour chaque mot-clé et chaque AI Provider
start_date = 3.days.ago.to_date
end_date = Date.today

(start_date..end_date).each do |date|
  keywords.each do |keyword|
    ai_providers.each do |provider|
      position_score = rand(50..100)
      frequency_score = rand(40..90)
      url_present = [true, false].sample
      url_score = url_present ? 100 : 0

      # Simulation de réponses des IA
      ai_responses = [
        "Meilleure formation IA",
        "Le Wagon Data Science",
        "OpenClassrooms AI",
        "Coursera AI Bootcamp"
      ].sample(2)

      GeoScoring.create!(
        keyword: keyword,
        ai_provider: provider,
        position_score: position_score,
        frequency_score: frequency_score,
        url_presence: url_present ? 100 : 0,
        url_score: url_score,
        ai_responses: ai_responses,
        created_at: date.to_time + rand(0..23).hours
      )
    end
  end
end

puts "===> GeoScoring data created for 3 days!"





# # Utilisateurs sans company associée (pour tester la modal QuickStart)
# noCompany = User.create!(email: "nocompany@gmail.com", password: "azerty", company: nil)
# puts "Users created"

# ai_providers = AiProvider.create!([
#   { name: "openai" },
#   { name: "anthropic" },
#   { name: "perplexity" }
# ])


# companies = Company.all
# keywords = Keyword.create!([
#   { content: "Meilleure formation en intelligence artificielle en ligne", company: company },
#   { content: "Meilleur bootcamp de Machine Learning ?", company: company },
#   { content: "Top écoles pour apprendre la Data Science", company: company },
#   { content: "Formation Cloud Computing la plus reconnue en 2025", company: company },
#   { content: "Comparaison des meilleures formations en automatisation des tâches", company: company }
# ])
# puts "Keywords created"

# AiProvider.find_each do |ai_provider|
#   CompanyAiProvider.create!(company: company, ai_provider: ai_provider)
# end
# puts "Association done"

# # Création des requêtes sur 3 jours
# end_time = Time.now - 10.minutes
# (Date.new(2024, 9, 1)..end_time.to_date).each do |date|
#   max_hour = date == end_time.to_date ? end_time.hour : 23
#   ["https://www.chatgpt.com", "http://www.claude.ai", "http://www.perplexity.ai"].each do |referrer|
#     rand(5..15).times do |i|
#       created_time = date.to_time + rand(max_hour + 1).hours

#       next if created_time > end_time

#       Request.create!(
#         domain: ["https://www.lewagon.com", "https://www.airbnb.com", "https://www.uber.com", "https://www.github.com"].sample,
#         path: ["/learn", "/repos"],
#         user_agent: "Mozilla/5.0",
#         company: company,
#         created_at: created_time,
#         referrer: referrer
#       )
#       puts "request n°#{Request.count} created"
#     end
#   end
# end
# puts "requests created"

# competitors = Competitor.create!([
#   { name: "Competitor 1", domain: "https://www.competitor1.com", company: company },
#   { name: "Competitor 2", domain: "https://www.competitor2.com", company: company  },
#   { name: "Competitor 3", domain: "https://www.competitor3.com", company: company  },
#   { name: "Competitor 4", domain: "https://www.competitor4.com", company: company  },
#   { name: "Competitor 5", domain: "https://www.competitor5.com", company: company  }
# ])
# puts "Competitors created"

# keywords = Keyword.all


# puts "geo_scoring historiques créés"

# # Création des geo_scorings actuels pour les scores des concurrents
# current_geo_scorings = []

# puts "geo_scoring actuels créés"

# # Création des geo_scorings pour chaque mot-clé et fournisseur d'IA
# puts "Creating geo_scorings..."

# urls = ['https://www.le-wagon-bar.vercel.app/', 'https://www.google.com/', nil]
# (Date.new(2024, 9, 1)..Date.today).each do |date|
#   company.keywords.each do |keyword|
#     company.ai_providers.each do |ai_provider|
#       mention = (rand(10) % 2).even?
#       GeoScoring.create!(
#         keyword: keyword,
#         ai_provider: ai_provider,
#         mentioned: mention,
#         ai_responses: ['wagon', 'google', 'le wagon bar', 'openclassrooms'].shuffle,
#         url: urls.sample,
#         created_at: date
#       )
#     end
#   end
# end

# puts "Finished creating geo_scorings!"
