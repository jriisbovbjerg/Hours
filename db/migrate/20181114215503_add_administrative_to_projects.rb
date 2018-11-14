class AddAdministrativeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :administrative, :boolean
    add_index :projects, :administrative
    
  end
end
