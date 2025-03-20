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

# Utilisateurs sans company associée (pour tester la modal QuickStart)
noCompany = User.create!(email: "nocompany@gmail.com", password: "azerty", company: nil)
puts "Users created"

ai_providers = AiProvider.create!([
  { name: "openai" },
  { name: "anthropic" },
  { name: "perplexity" }
])


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
end_time = Time.now - 10.minutes
(Date.new(2024, 9, 1)..end_time.to_date).each do |date|
  max_hour = date == end_time.to_date ? end_time.hour : 23
  ["https://www.chatgpt.com", "http://www.claude.ai", "http://www.perplexity.ai"].each do |referrer|
    rand(5).times do |i|
      created_time = date.to_time + rand(max_hour + 1).hours

      next if created_time > end_time

      Request.create!(
        domain: ["https://www.lewagon.com", "https://www.airbnb.com", "https://www.uber.com", "https://www.github.com","https://le-wagon-bar.vercel.app/"].sample,
        path: ["/learn", "/repos"],
        user_agent: "Mozilla/5.0",
        company: company,
        created_at: created_time,
        referrer: referrer
      )
      puts "request n°#{Request.count} created"
    end
  end
end

end_time = Time.now - 10.minutes
(Date.new(2024, 9, 1)..end_time.to_date).each do |date|
  max_hour = date == end_time.to_date ? end_time.hour : 23
  ["https://www.google.com", "https://le-wagon-bar.vercel.app/"].each do |referrer|
    rand(5..15).times do |i|
      created_time = date.to_time + rand(max_hour + 1).hours

      next if created_time > end_time

      Request.create!(
        domain: ["https://www.lewagon.com", "https://le-wagon-bar.vercel.app/", "https://www.uber.com", "https://www.github.com"].sample,
        path: ["/learn", "/repos"],
        user_agent: "Mozilla/5.0",
        company: company,
        created_at: created_time,
        referrer: referrer
      )
      puts "request n°#{Request.count} created"
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


puts "geo_scoring historiques créés"

# Création des geo_scorings actuels pour les scores des concurrents
current_geo_scorings = []

puts "geo_scoring actuels créés"

# Création des geo_scorings pour chaque mot-clé et fournisseur d'IA
puts "Creating geo_scorings..."

urls = [
  'https://www.le-wagon-bar.vercel.app/', 
  'https://www.le-wagon-bar.vercel.app/', 
  'https://www.le-wagon-bar.vercel.app/', 
  'https://www.le-wagon-bar.vercel.app/', 
  'https://www.le-wagon-bar.vercel.app/', 
  'https://www.le-wagon-bar.vercel.app/', 
  'https://www.google.com/',
  'https://www.google.com/',
  'https://www.google.com/',
  nil
]
(Date.new(2024, 9, 1)..Date.today).each do |date|
  company.keywords.each do |keyword|
    company.ai_providers.each do |ai_provider|
      mention = rand(10) > 2
      GeoScoring.create!(
        keyword: keyword,
        ai_provider: ai_provider,
        mentioned: mention,
        ai_responses: ['wagon', 'google', 'le wagon bar', 'openclassrooms'].shuffle,
        url: urls.sample,
        created_at: date
      )
    end
  end
end

puts "Finished creating geo_scorings!"
