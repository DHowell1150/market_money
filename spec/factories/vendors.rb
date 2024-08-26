FactoryBot.define do
  factory :vendor do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    contact_name { Faker::Book.author }
    contact_phone { Faker::PhoneNumber.phone_number }
    credit_accepted { Faker::Boolean.boolean }
  end
end