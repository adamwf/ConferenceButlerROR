class AddFeedToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :feeds, :boolean, default: true
    add_column :admin_users, :adds, :boolean, default: true
    add_column :admin_users, :shop, :boolean, default: true
    add_column :admin_users, :discover, :boolean, default: true
  end
end
