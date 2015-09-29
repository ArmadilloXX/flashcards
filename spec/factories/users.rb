FactoryGirl.define do
  factory :user do
    email "test@test.com"
    password "12345"
    password_confirmation "12345"
    locale "ru"
    current_block_id ""
  end
end
