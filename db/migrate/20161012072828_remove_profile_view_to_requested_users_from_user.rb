class RemoveProfileViewToRequestedUsersFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :profile_view_to_requested_users, :boolean
    remove_column :users, :profile_view_to_handle_directory_users, :boolean
    remove_column :users, :profile_view_to_gab_users, :boolean
    remove_column :users, :profile_display_within_search_engine, :boolean
    add_column :users, :profile_view_to_requested_users, :boolean, default: true
    add_column :users, :profile_view_to_handle_directory_users, :boolean, default: true
    add_column :users, :profile_view_to_gab_users, :boolean, default: true
    add_column :users, :profile_display_within_search_engine, :boolean, default: true
  end
end
