# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :request do
    user_id 1
    title "Example Title"
    description "Example Description"
    start_date Date.today
    end_date Date.today + 1.month
    group_name "Group Name"
    office_name "Office Name"
  end
end
