FactoryBot.define do
  trait :sequence_stock_name do
    sequence(:name) { |n| "Stock #{n + 1}" }
  end

  factory :stock do
  end
end
