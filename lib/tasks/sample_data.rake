namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    require 'faker'

    User.create!(name: "Chris",
                 email: "chris@sample.com",
                 password: "password",
                 password_confirmation: "password")

    User.create!(name: "Lee",
                 email: "lee@sample.com",
                 password: "password",
                 password_confirmation: "password")

    @positions = ["Engineer", "Analyst", "Project Lead", "UI Specialist", "QA Specialist"]
    @departments = ["IT", "Marketing", "Analytics", "Research"]
    @groups = ["Development", "Interface Design","QA","Infrastructure"]
    @locations = ["Chicago",  "Mumbai", "Houston", "San Francisco", "Boston", "London"]

    #Current and Future Skills
    puts "Generating Sample Current Skills"
    130.times do |n|
      3.times do |s|
        CurrentSkill.create!(
          skill_id: s+1,
          user_id: n+1,
          proficiency_level: rand(0..4)
        )
        DesiredSkill.create!(
          skill_id: s+1,
          user_id: n+1,
          interest_level: rand(0..4)
        )
      end
    end

    #User Breakdown: 45 in Chicago, 20 in Boston, 32 in Houston, 14 in San Francisco, 12 in London, 5 in Mumbai

    puts "Generating Sample Users"
    
    #Chicago Users
    45.times do
      User.create!(name: Faker::Name.name,
                   email: Faker::Internet.email,
                   password: "password",
                   password_confirmation: "password",
                   years_with_company: rand(1..20),
                   manager: "Chris",
                   u_position: @positions.sample.to_s,
                   u_department: @departments.sample.to_s,
                   u_group: @groups.sample.to_s,
                   u_location: "Chicago")
    end

    #Boston Users
    20.times do
      User.create!(name: Faker::Name.name,
                   email: Faker::Internet.email,
                   password: "password",
                   password_confirmation: "password",
                   years_with_company: rand(1..20),
                   manager: "Linda",
                   u_position: @positions.sample.to_s,
                   u_department: @departments.sample.to_s,
                   u_group: @groups.sample.to_s,
                   u_location: "Boston")
    end

    #Houston Users
    32.times do
      User.create!(name: Faker::Name.name,
                   email: Faker::Internet.email,
                   password: "password",
                   password_confirmation: "password",
                   years_with_company: rand(1..20),
                   manager: "Jane",
                   u_position: @positions.sample.to_s,
                   u_department: @departments.sample.to_s,
                   u_group: @groups.sample.to_s,
                   u_location: "Houston")
    end

    #San Francisco Users
    14.times do
      User.create!(name: Faker::Name.name,
                   email: Faker::Internet.email,
                   password: "password",
                   password_confirmation: "password",
                   years_with_company: rand(1..20),
                   manager: "Ethan",
                   u_position: @positions.sample.to_s,
                   u_department: @departments.sample.to_s,
                   u_group: @groups.sample.to_s,
                   u_location: "San Francisco")
    end

    
    #Mumbai Users
    5.times do
      User.create!(name: Faker::Name.name,
                   email: Faker::Internet.email,
                   password: "password",
                   password_confirmation: "password",
                   years_with_company: rand(1..20),
                   manager: "James",
                   u_position: @positions.sample.to_s,
                   u_department: @departments.sample.to_s,
                   u_group: @groups.sample.to_s,
                   u_location: "Mumbai")
    end    

    #London Users
    12.times do
      User.create!(name: Faker::Name.name,
                   email: Faker::Internet.email,
                   password: "password",
                   password_confirmation: "password",
                   years_with_company: rand(1..20),
                   manager: "John",
                   u_position: @positions.sample.to_s,
                   u_department: @departments.sample.to_s,
                   u_group: @groups.sample.to_s,
                   u_location: "London")
    end    

    def get_random_start_date
      Array((Date.today - 3.months)..(Date.today + 3.months)).sample
    end
    
    puts 'Generating Sample Requests'
    
    #3 Users posted once
    3.times do |n|
      Request.create!(title: Faker::Lorem.words(2).join(" ").to_s.capitalize,
                      description: Faker::Lorem.sentences(2).join(" "),
                      start_date: start_date = get_random_start_date,
                      end_date: start_date + rand(1..90).days,
                      group_name: @groups.sample.to_s,
                      user_id: user_id = n+4,
                      office_name: User.find_by_id(user_id).u_location)
    end

    #User #1 over 10 requests
    17.times do 
      Request.create!(title: Faker::Lorem.words(2).join(" ").to_s.capitalize,
                      description: Faker::Lorem.sentences(2).join(" "),
                      start_date: start_date = get_random_start_date,
                      end_date: start_date + rand(1..90).days,
                      group_name: @groups.sample.to_s,
                      user_id: "7",
                      office_name: User.find_by_id("5").u_location)
    end

    #User #2 over 10 requests
    20.times do 
      Request.create!(title: Faker::Lorem.words(2).join(" ").to_s.capitalize,
                      description: Faker::Lorem.sentences(2).join(" "),
                      start_date: start_date = get_random_start_date,
                      end_date: start_date + rand(1..90).days,
                      group_name: @groups.sample.to_s,
                      user_id: "8",
                      office_name: User.find_by_id("6").u_location)
    end

    #Remaining Requests
    20.times do
    n = rand(9..User.all.length)
      4.times do
        Request.create!(title: Faker::Lorem.words(2).join(" ").to_s.capitalize,
                        description: Faker::Lorem.sentences(2).join(" "),
                        start_date: start_date = get_random_start_date,
                        end_date: start_date + rand(1..90).days,
                        group_name: @groups.sample.to_s,
                        user_id: user_id = n,
                        office_name: User.find_by_id(user_id).u_location) 
      end
    end 

    #Relevant Skills 
    puts 'Generating Sample Relevant Skills'   
    120.times do |n|
      RelevantSkill.create!(
        skill_id: rand(1..7),
        request_id: n)
    end

    #Request Response Details:
    # 70 responses:
    # 9 local, i.e., came from developers at the office where the request originated
    # 2 personal, i.e., a developer responded to their own request
    # 0 to Mumbai Requests
    # All requests from London received at least 3 responses
    # Some responses occurred a day after the request, some 2 days after, some 4, and some 8

    puts 'Generating Sample Responses'
    
    @response_locations = ["Chicago", "Houston", "San Francisco", "Boston"]
   
    def get_random_response_datetime(request_date)
      [(request_date + 1.day), (request_date + 2.days), (request_date + 4.days), (request_date + 8.days)].sample
    end

    def find_response_user_with_request(u_location)
      user_id = User.find_all_by_u_location(u_location).map(&:id).sample
      request_id = Request.find_all_by_user_id(user_id).map(&:id).sample
      request_id == nil ? find_response_user_with_request(u_location) : user_id
    end

    def find_unique_location(u_location)
      unique_location = @response_locations.sample
      unique_location == u_location ? find_unique_location(u_location) : unique_location
    end

    #Local responses
    9.times do
      u_location = @response_locations.sample
      user_id = User.find_all_by_u_location(u_location).map(&:id).sample
      request_id = Request.find_all_by_office_name(u_location).map(&:id).sample
      
      Response.create!(
        comment: Faker::Lorem.sentences(2).join(" "),
        request_id: request_id,
        user_id: user_id,
        created_at: get_random_response_datetime(Request.find_by_id(request_id).start_date))
    end
    #Personal responses
    2.times do
      u_location = @response_locations.sample
      user_id = find_response_user_with_request(u_location)
      request_id = Request.find_all_by_user_id(user_id).map(&:id).sample

      Response.create!(
        comment: Faker::Lorem.sentences(2).join(" "),
        request_id: request_id,
        user_id: user_id,
        created_at: get_random_response_datetime(Request.find_by_id(request_id).start_date))
    end      
    #Remaining responses w/ no Mumbai and not local
    59.times do
      u_location = @response_locations.sample
      other_location = find_unique_location(u_location)
      user_id = User.find_all_by_u_location(u_location).map(&:id).sample
      request_id = Request.find_all_by_office_name(other_location).map(&:id).sample

      Response.create!(
      comment: Faker::Lorem.sentences(2).join(" "),
      request_id: request_id,
      user_id: user_id,
      created_at: get_random_response_datetime(Request.find_by_id(request_id).start_date))
    end 

    # Request Assignment Details:
    # 50 request assignments:
    # 7 of the 9 local responses selected
    # 1 of the 2 personal responses selected
    # Some responses are selected on the same day as a response, some a day later, some 3 days later, and some 5

    def get_random_request_assignment_datetime(request_date)
      [ (request_date), (request_date + 1.day), (request_date + 3.days), (request_date + 5.days)].sample
    end

    puts 'Generating Sample Request Assignments'
    #local request assignments
    7.times do |n|
      response_id = n+2

      Assignment.create!(
      comment: Faker::Lorem.sentences(2).join(" "),
      created_at: get_random_request_assignment_datetime(Response.find_by_id(response_id).created_at),
      response_id: response_id)
    end

    #personal request_assignment
      Assignment.create!(
      comment: Faker::Lorem.sentences(2).join(" "),
      created_at: get_random_request_assignment_datetime(Response.find_by_id(10).created_at),
      response_id: '10')

    #Remaining Request Assignments
    42.times do |n|
      response_id = n+11
      
      Assignment.create!(
      comment: Faker::Lorem.sentences(2).join(" "),
      created_at: get_random_request_assignment_datetime(Response.find_by_id(response_id).created_at),
      response_id: response_id)
    end
  end
end
