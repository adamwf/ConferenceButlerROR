class CreateProfileViews < ActiveRecord::Migration
  def change
    create_table :profile_views do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :viewer_id

      t.timestamps null: false
    end
  end
end
