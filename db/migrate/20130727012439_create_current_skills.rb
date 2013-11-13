class CreateCurrentSkills < ActiveRecord::Migration
  def change
    create_table :current_skills do |t|
      t.integer :skill_id
      t.integer :user_id

      t.timestamps
    end
  end
end
