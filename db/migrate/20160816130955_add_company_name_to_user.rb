class AddCompanyNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :company_name, :string
    add_column :users, :company_website, :string
    add_column :users, :fax, :string
    add_column :users, :facebook, :string
    add_column :users, :instagram, :string
    add_column :users, :youtube, :string
  end
end
