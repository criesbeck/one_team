class Skill < ActiveRecord::Base
  has_many :relevant_skills, dependent: :destroy
  has_many :requests, through: :relevant_skills

  has_many :desired_skills, dependent: :destroy
  has_many :users, through: :desired_skills

  has_many :current_skills, dependent: :destroy
  has_many :users, through: :current_skills
end
