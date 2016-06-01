class AddRoleToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :role, :string
    add_column :admin_users, :status, :boolean, default: :true
  end
end
