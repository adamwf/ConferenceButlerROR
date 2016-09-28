class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :group_name
      t.string :group_image
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
