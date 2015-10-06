FactoryGirl.define do
  factory :user do
    email "test@test.com"
    password "12345"
    password_confirmation "12345"
    locale "ru"
    current_block_id ""

    trait :admin do
      after(:create) do |user|
        user.add_role :admin
      end
    end
  end
end
