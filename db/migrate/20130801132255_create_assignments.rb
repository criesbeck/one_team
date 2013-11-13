class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :response_id
      t.string :comment

      t.timestamps
    end
  end
end
