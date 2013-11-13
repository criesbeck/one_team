# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :response do
    request_id 1
    user_id 1
    comment "MyString"
  end
end
