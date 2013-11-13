class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.date :start_date
      t.date :end_date
      t.string :group_name
      t.string :office_name
      t.date :date_completed
      t.date :date_cancelled

      t.timestamps
    end
  end
end
