class AddStatusToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :status, :boolean, default: :true
  end
end
