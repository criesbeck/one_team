class Assignment < ActiveRecord::Base
  belongs_to :response
  belongs_to :user
  belongs_to :request
  has_many :evaluations
  accepts_nested_attributes_for :evaluations
end
