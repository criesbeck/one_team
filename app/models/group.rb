class Group < ActiveRecord::Base
  belongs_to :request
  belongs_to :user
end
