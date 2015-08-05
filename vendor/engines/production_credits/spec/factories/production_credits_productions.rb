# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :production_credits_production, :class => 'ProductionCredits::Production' do
    production_name { Faker::Lorem.words(rand(3) + 1).join(' ') }
    open_on { Date.today - 1 }
    close_on { Date.today + 1 }
    work nil
  end
end
