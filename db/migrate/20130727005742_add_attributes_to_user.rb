class AddAttributesToUser < ActiveRecord::Migration
  def change
    add_column :users, :years_with_company, :integer
    add_column :users, :manager, :string
    add_column :users, :u_position, :string
    add_column :users, :u_department, :string
    add_column :users, :u_group, :string
    add_column :users, :u_location, :string
    add_column :users, :avatar, :string
  end
end
