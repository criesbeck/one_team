class AddProficiencyLevelToCurrentSkill < ActiveRecord::Migration
  def change
    add_column :current_skills, :proficiency_level, :integer, :default => 0
    add_column :desired_skills, :interest_level, :integer,  :default => 0
  end
end
