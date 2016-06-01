class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.string :title, default: ""
      t.string :image
      t.text :discription, default: ""
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
