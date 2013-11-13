class RelevantSkill < ActiveRecord::Base
  belongs_to :skill
  belongs_to :request
end
