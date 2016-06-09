class AddProviderToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :provider, :string
    add_column :users, :u_id, :string
  end
end
