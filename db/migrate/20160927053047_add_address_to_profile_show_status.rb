class AddAddressToProfileShowStatus < ActiveRecord::Migration
  def change
    add_column :profile_show_statuses, :address, :boolean, default: true
    add_reference :profile_show_statuses, :user, index: true, foreign_key: true
  end
end
