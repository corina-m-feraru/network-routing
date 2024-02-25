FactoryBot.define do
  factory :router_link do
    router
    association :linked_router, factory: :router
  end
end