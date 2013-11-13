# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Oneteam2::Application.initialize!

my_date_formats = { :default => '%B %e, %Y' } 
Time::DATE_FORMATS.merge!(my_date_formats) 
Date::DATE_FORMATS.merge!(my_date_formats)