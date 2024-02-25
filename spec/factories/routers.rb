FactoryBot.define do
  factory :router do
    name { 'Router 1' }
    location { create(:location) }
  end
end
