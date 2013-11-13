class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :experience_points
      t.integer :proficiency_level_judgment
      t.integer :assignment_id
      t.integer :skill_id

      t.timestamps
    end
  end
end
