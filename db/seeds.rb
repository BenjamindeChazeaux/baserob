# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "destroy all datas"
CompanyAiProvider.destroy_all
CompetitorScore.destroy_all
GeoScoring.destroy_all
Competitor.destroy_all
Request.destroy_all
Keyword.destroy_all
AiProvider.destroy_all
User.destroy_all
Company.destroy_all

companies = Company.create!([
  { name: "Le Wagon", domain: "https://www.lewagon.com" },
  { name: "Airbnb", domain: "https://www.airbnb.com" },
  { name: "Uber", domain: "https://www.uber.com" },
  { name: "Spotify", domain: "https://www.spotify.com" },
  { name: "GitHub", domain: "https://www.github.com" }
])
puts "Company created"

company = Company.first

Ben = User.create!(email: "ben@gmail.com", password: "password1", company: company)
Anh = User.create!(email: "anh@gmail.com", password: "password2", company: company)
Antoine = User.create!(email: "antoine@gmail.com", password: "password3", company: company)
Yannick = User.create!(email: "yannick@gmail.com", password: "password4", company: company)

ai_providers = AiProvider.create!([
  { name: "OpenAI" },
  { name: "Google DeepMind" },
  { name: "Anthropic" },
  { name: "Cohere" },
  { name: "Mistral" }
])

companies = Company.all
keywords = Keyword.create!([
  { content: "AI", company: company },
  { content: "Machine Learning", company: company },
  { content: "Data Science", company: company },
  { content: "Cloud Computing", company: company },
  { content: "Automation", company: company }
])


AiProvider.find_each do |ai_provider|
  CompanyAiProvider.create!(company: company, ai_provider: ai_provider)
end

requests = Request.create!([
  {
    domain: "https://www.lewagon.com",
    path: "/learn",
    referrer: "google.com",
    user_agent: "Mozilla/5.0",
    company: company,
    ai_provider: ai_providers.first
  },
  {
    domain: "https://www.airbnb.com",
    path: "/host",
    referrer: "facebook.com",
    user_agent: "Mozilla/5.0",
    company: company,
    ai_provider: ai_providers.second
  },
  {
    domain: "https://www.uber.com",
    path: "/ride",
    referrer: "twitter.com",
    user_agent: "Mozilla/5.0",
    company: company,
    ai_provider: ai_providers.third
  },
  {
    domain: "https://www.spotify.com",
    path: "/premium",
    referrer: "youtube.com",
    user_agent: "Mozilla/5.0",
    company: company,
    ai_provider: ai_providers.fourth
  },
  {
    domain: "https://www.github.com",
    path: "/repos",
    referrer: "linkedin.com",
    user_agent: "Mozilla/5.0",
    company: company,
    ai_provider: ai_providers.fifth
  }
])


competitors = Competitor.create!([
  { name: "Competitor 1", domain: "https://www.competitor1.com", company: company },
  { name: "Competitor 2", domain: "https://www.competitor2.com", company: company  },
  { name: "Competitor 3", domain: "https://www.competitor3.com", company: company  },
  { name: "Competitor 4", domain: "https://www.competitor4.com", company: company  },
  { name: "Competitor 5", domain: "https://www.competitor5.com", company: company  }
])


keywords = Keyword.all

geo_scorings = GeoScoring.create!([
  { score: 85, frequency_score: 90, position_score: 80, link_score: 75, keyword: keywords.first, ai_provider: ai_providers.first},
  { score: 70, frequency_score: 65, position_score: 72, link_score: 80, keyword: keywords.second, ai_provider: ai_providers.second},
  { score: 90, frequency_score: 88, position_score: 85, link_score: 92, keyword: keywords.third, ai_provider: ai_providers.third},
  { score: 65, frequency_score: 60, position_score: 70, link_score: 65, keyword: keywords.fourth, ai_provider: ai_providers.fourth},
  { score: 78, frequency_score: 80, position_score: 75, link_score: 70, keyword: keywords.fifth, ai_provider: ai_providers.fifth}
])

competitor_scores = CompetitorScore.create!([
  {
    score: 85,
    frequency_score: 90,
    position_score: 80,
    link_score: 75,
    competitor: competitors.first,
    geo_scoring: geo_scorings.first
  },
  {
    score: 70,
    frequency_score: 65,
    position_score: 72,
    link_score: 80,
    competitor: competitors.second,
    geo_scoring: geo_scorings.second
  },
  {
    score: 90,
    frequency_score: 88,
    position_score: 85,
    link_score: 92,
    competitor: competitors.third,
    geo_scoring: geo_scorings.third
  },
  {
    score: 65,
    frequency_score: 60,
    position_score: 70,
    link_score: 65,
    competitor: competitors.fourth,
    geo_scoring: geo_scorings.fourth
  },
  {
    score: 78,
    frequency_score: 80,
    position_score: 75,
    link_score: 70,
    competitor: competitors.fifth,
    geo_scoring: geo_scorings.fifth
  }
])
