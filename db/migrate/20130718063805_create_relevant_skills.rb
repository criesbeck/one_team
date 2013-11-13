class CreateRelevantSkills < ActiveRecord::Migration
  def change
    create_table :relevant_skills do |t|
      t.integer :skill_id
      t.integer :request_id

      t.timestamps
    end
  end
end
