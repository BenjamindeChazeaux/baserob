FactoryBot.define do
  factory :geo_scoring do
    association :keyword
    association :ai_provider
    position_score { rand(0..100) }
    reference_score { rand(0..100) }
    url_presence { [true, false].sample }
    url_value { "https://example.com" }
    ai_responses { ["Response 1", "Response 2", "Response 3"] }
  end
end
