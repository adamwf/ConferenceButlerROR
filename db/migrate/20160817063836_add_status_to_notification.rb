class AddStatusToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :status, :boolean, default: false
  end
end
