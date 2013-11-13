FactoryGirl.define do
  factory :user do
    name 'Test User'
    email 'example@example.com'
    password 'changeme'
    password_confirmation 'changeme'
    years_with_company 1
    manager "Example Manager"
    u_position "Example Position"
    u_department "Example Department"
    u_group "Example Group"
    u_location "Example Location"
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end
end
