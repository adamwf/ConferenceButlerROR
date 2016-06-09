class AddStatusToAdvertisement < ActiveRecord::Migration
  def change
    add_column :advertisements, :status, :boolean, default: true
    add_column :advertisements, :priority, :integer
  end
end
