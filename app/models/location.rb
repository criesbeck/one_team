class Location < ActiveRecord::Base
  belongs_to :request
  belongs_to :user
end
