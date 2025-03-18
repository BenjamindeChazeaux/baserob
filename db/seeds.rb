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
  { name: "Le Wagon Bar", domain: "https://www.lewagon.com", token: 'c52cf53345ce51d8e20ad727386e239a' },
  { name: "Airbnb", domain: "https://www.airbnb.com" },
  { name: "Uber", domain: "https://www.uber.com" },
  { name: "Spotify", domain: "https://www.spotify.com" },
  { name: "GitHub", domain: "https://www.github.com" }
])
puts "Company created"

company = Company.first

# Utilisateurs avec company associée
ben = User.create!(email: "ben@gmail.com", password: "password1", company: company)
anh = User.create!(email: "anh@gmail.com", password: "password2", company: company)
antoine = User.create!(email: "antoine@gmail.com", password: "password3", company: company)
yannick = User.create!(email: "yannick@gmail.com", password: "password4", company: company)
test = User.create!(email: "test@test.com", password: "azerty", company: company)



competitors = Competitor.create!([
  { name: "Competitor 1", domain: "https://www.competitor1.com", company: company },
  { name: "Competitor 2", domain: "https://www.competitor2.com", company: company  },
  { name: "Competitor 3", domain: "https://www.competitor3.com", company: company  },
  { name: "Competitor 4", domain: "https://www.competitor4.com", company: company  },
  { name: "Competitor 5", domain: "https://www.competitor5.com", company: company  }
])
puts "Competitors created"


# 2️⃣ Ajout de fournisseurs d'IA (OpenAI, Perplexity, Anthropic)
openai = AiProvider.create!(name: "openai")
perplexity = AiProvider.create!(name: "perplexity")
anthropic = AiProvider.create!(name: "anthropic")

# 3️⃣ Associer ces AI Providers à l'entreprise
company.ai_providers << openai
company.ai_providers << perplexity
company.ai_providers << anthropic

# 4️⃣ Création d'un mot-clé de test
# 4️⃣ Création de mots-clés de test
keywords = Keyword.create!([
  { content: "Meilleure formation IA", company: company },
  { content: "Meilleur bootcamp de Machine Learning ?", company: company },
  { content: "Top écoles pour apprendre la Data Science", company: company },
  { content: "Formation Cloud Computing la plus reconnue en 2025", company: company },
  { content: "Comparaison des meilleures formations en automatisation des tâches", company: company }
])

puts "Keywords created"

# 5️⃣ Génération de GeoScoring avec des scores fictifs pour chaque AI Provider
# On prend uniquement le premier mot-clé pour tester
keyword_1 = keywords.first  # ✅ Utiliser le premier mot-clé
keyword_2 = keywords.second # ✅ Utiliser le second mot-clé pour plus de tests

GeoScoring.create!(
  keyword: keyword_1,  # ✅ Maintenant `keyword_1` est un seul objet
  ai_provider: openai,
  position_score: 75,
  reference_score: 60,
  url_presence: 80
)

GeoScoring.create!(
  keyword: keyword_1,
  ai_provider: perplexity,
  position_score: 55,
  reference_score: 70,
  url_presence: 50
)

GeoScoring.create!(
  keyword: keyword_1,
  ai_provider: anthropic,
  position_score: 90,
  reference_score: 85,
  url_presence: 95
)

# On ajoute aussi des données pour le deuxième mot-clé
GeoScoring.create!(
  keyword: keyword_2,
  ai_provider: openai,
  position_score: 65,
  reference_score: 50,
  url_presence: 70
)

GeoScoring.create!(
  keyword: keyword_2,
  ai_provider: perplexity,
  position_score: 80,
  reference_score: 75,
  url_presence: 60
)

GeoScoring.create!(
  keyword: keyword_2,
  ai_provider: anthropic,
  position_score: 95,
  reference_score: 90,
  url_presence: 85
)

puts "GeoScoring created"
