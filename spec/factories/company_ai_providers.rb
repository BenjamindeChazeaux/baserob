FactoryBot.define do
  factory :company_ai_provider do
    association :company
    association :ai_provider
  end
end
