class CreateTrendings < ActiveRecord::Migration
  def change
    create_table :trendings do |t|
      t.integer :count
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
