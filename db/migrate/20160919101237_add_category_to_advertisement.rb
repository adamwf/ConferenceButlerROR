class AddCategoryToAdvertisement < ActiveRecord::Migration
  def change
    add_column :advertisements, :category, :string
  end
end
