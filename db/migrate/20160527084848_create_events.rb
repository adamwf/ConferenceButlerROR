class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :location
      t.datetime :time
      t.string :organizer
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
