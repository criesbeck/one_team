
puts 'DEFAULT USERS'
user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
puts 'user: ' << user.name
user.add_role :admin

puts 'DEPARTMENTS'
departments = Department.create([{ name: 'IT'}, { name: 'Marketing'}, {name: 'Analytics'}, {name: 'Research'}])

puts 'POSITIONS'
positions = Position.create([{ name: 'Engineer'}, { name: 'Analyst'}, {name: 'Project Lead'}, {name: 'UI Specialist'}, {name: 'QA Specialist'}])

puts 'GROUPS'
groups = Group.create([{ name: 'Development'}, { name: 'Interface Design'}, {name: 'QA'}, {name: 'Infrastructure'}])

puts 'LOCATIONS'
locations = Location.create([{name: 'Boston'}, { name: 'Chicago'}, { name: 'Mumbai'}, {name: 'Houston'}, {name: 'London'}, {name: 'San Francisco'}])

puts 'SKILLS'
skills = Skill.create([{ name: 'PHP'}, { name: 'MySQL'}, {name: 'C#'}, {name: 'Apache'}, {name: 'Ruby on Rails'}, {name: 'SQL Server'}, {name: 'Linux'}])
