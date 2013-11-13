class Evaluation < ActiveRecord::Base
  belongs_to :request
  belongs_to :assignment
  belongs_to :user
end
