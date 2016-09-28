class AddAccessTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :access_token, :string
    add_column :users, :hobbies, :string
    add_column :users, :relation_status, :string
    add_column :users, :children, :string
    add_column :users, :availability, :boolean, default: true
    add_column :users, :other_info, :text
    add_column :users, :profile_view_to_requested_users, :boolean
    add_column :users, :profile_view_to_handle_directory_users, :boolean
    add_column :users, :profile_view_to_gab_users, :boolean
  end
end
