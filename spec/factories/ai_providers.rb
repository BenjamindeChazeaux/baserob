FactoryBot.define do
  factory :ai_provider do
    sequence(:name) { |n| "AI Provider #{n}" }
  end
end
