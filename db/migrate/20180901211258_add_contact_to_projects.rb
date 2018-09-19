class AddContactToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :contact_id, :integer
  end
end
