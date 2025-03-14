# Nettoyage de la base de données
CompanyAiProvider.destroy_all
CompetitorScore.destroy_all
GeoScoring.destroy_all
Competitor.destroy_all
Request.destroy_all
Keyword.destroy_all
AiProvider.destroy_all
User.destroy_all
Company.destroy_all
puts "seed destroyed"

companies = Company.create!([
  { name: "Le Wagon", domain: "https://www.lewagon.com", token: 'c52cf53345ce51d8e20ad727386e239a' },
  { name: "Airbnb", domain: "https://www.airbnb.com" },
  { name: "Uber", domain: "https://www.uber.com" },
  { name: "Spotify", domain: "https://www.spotify.com" },
  { name: "GitHub", domain: "https://www.github.com" }
])
puts "Company created"

company = Company.first

# Utilisateurs avec company associée
test = User.create!(email: "test@test.com", password: "azerty", company: company)
Ben = User.create!(email: "ben@gmail.com", password: "password1", company: company)
Anh = User.create!(email: "anh@gmail.com", password: "password2", company: company)
Antoine = User.create!(email: "antoine@gmail.com", password: "password3", company: company)
Yannick = User.create!(email: "yannick@gmail.com", password: "password4", company: company)

# Utilisateurs sans company associée (pour tester la modal QuickStart)
NoCompany = User.create!(email: "nocompany@gmail.com", password: "password5", company: nil)
puts "Users created"

ai_providers = AiProvider.create!([
  { name: "openai" },
  { name: "anthropic" },
  { name: "perplexity" }
])
puts ai_providers.inspect

companies = Company.all
keywords = Keyword.create!([
  { content: "Meilleure formation en intelligence artificielle en ligne", company: company },
  { content: "Meilleur bootcamp de Machine Learning ?", company: company },
  { content: "Top écoles pour apprendre la Data Science", company: company },
  { content: "Formation Cloud Computing la plus reconnue en 2025", company: company },
  { content: "Comparaison des meilleures formations en automatisation des tâches", company: company }
])
puts "Keywords created"

AiProvider.find_each do |ai_provider|
  CompanyAiProvider.create!(company: company, ai_provider: ai_provider)
end
puts "Association done"

# Création des requêtes sur 3 jours
(Date.today - 2.days..Date.today).each do |date|
  ["https://www.openai.com", "http://www.anthropic.com", "http://www.perplexity.ai"].each do |referrer|
    rand(10).times do |i|
      Request.create!(
        domain: ["https://www.lewagon.com", "https://www.airbnb.com", "https://www.uber.com", "https://www.github.com"].sample,
        path: ["/learn", "/repos"],
        user_agent: "Mozilla/5.0",
        company: company,
        created_at: date,
        referrer: referrer
      )
    end
  end
end
puts "requests created"

competitors = Competitor.create!([
  { name: "Competitor 1", domain: "https://www.competitor1.com", company: company },
  { name: "Competitor 2", domain: "https://www.competitor2.com", company: company  },
  { name: "Competitor 3", domain: "https://www.competitor3.com", company: company  },
  { name: "Competitor 4", domain: "https://www.competitor4.com", company: company  },
  { name: "Competitor 5", domain: "https://www.competitor5.com", company: company  }
])
puts "Competitors created"

keywords = Keyword.all
# calculator = GeoScoringCalculatorService.new(company)

# # Création des geo_scorings historiques sur 3 jours
# (Date.today - 2.days..Date.today).each do |date|
#   Keyword.find_each do |keyword|
#     AiProvider.find_each do |ai_provider|
#       3.times do |i|
#         ai_responses = ["Le Wagon", "Ironhack", "App Academy", "Ahn Academy", 'Pouet school'].shuffle
#         scores = calculator.calculate_all_scores(ai_responses)

#         GeoScoring.create!(
#           keyword: keyword,
#           ai_provider: ai_provider,
#           position_score: scores[:position_score],
#           reference_score: scores[:reference_score],
#           url_presence: scores[:url_presence],
#           url_value: scores[:url_value],
#           ai_responses: ai_responses,
#           created_at: date
#         )
#       end
#     end
#   end
# end

puts "geo_scoring historiques créés"

# Création des geo_scorings actuels pour les scores des concurrents
current_geo_scorings = []
# keywords.each_with_index do |keyword, index|
#   ai_provider = ai_providers[index % ai_providers.length]
#   ai_responses = case index
#     when 0 then ["Le Wagon", "Ironhack", "App Academy", "Ahn Academy"]
#     when 1 then ["DataCamp", "Springboard", "Udacity", "Le Wagon", "Anthoine Academy"]
#     when 2 then ["General Assembly", "Le Wagon", "Lambda School", "Yanick Academy"]
#     when 3 then ["AWS Training", "Microsoft Learn", "Le Wagon", "Google Cloud Skills"]
#     when 4 then ["Zapier", "Automate.io", "Parabola", "Le Wagon"]
#   end

#   scores = calculator.calculate_all_scores(ai_responses)

#   current_geo_scorings << GeoScoring.create!(
#     keyword: keyword,
#     ai_provider: ai_provider,
#     position_score: scores[:position_score],
#     reference_score: scores[:reference_score],
#     url_presence: scores[:url_presence],
#     url_value: scores[:url_value],
#     ai_responses: ai_responses
#   )
# end

puts "geo_scoring actuels créés"

# competitor_scores = CompetitorScore.create!([
#   {
#     score: 85,
#     frequency_score: 90,
#     position_score: 80,
#     link_score: 75,
#     competitor: competitors.first,
#     geo_scoring: current_geo_scorings.first
#   },
#   {
#     score: 70,
#     frequency_score: 65,
#     position_score: 72,
#     link_score: 80,
#     competitor: competitors.second,
#     geo_scoring: current_geo_scorings.second
#   },
#   {
#     score: 90,
#     frequency_score: 88,
#     position_score: 85,
#     link_score: 92,
#     competitor: competitors.third,
#     geo_scoring: current_geo_scorings.third
#   },
#   {
#     score: 65,
#     frequency_score: 60,
#     position_score: 70,
#     link_score: 65,
#     competitor: competitors.fourth,
#     geo_scoring: current_geo_scorings.fourth
#   },
#   {
#     score: 78,
#     frequency_score: 80,
#     position_score: 75,
#     link_score: 70,
#     competitor: competitors.fifth,
#     geo_scoring: current_geo_scorings.fifth
#   }
# ])
# puts "Competitor_Score created"
