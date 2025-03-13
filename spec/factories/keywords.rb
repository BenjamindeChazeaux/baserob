FactoryBot.define do
  factory :keyword do
    sequence(:content) { |n| "Keyword #{n}" }
    association :company
  end
end
