class CreateUserEvents < ActiveRecord::Migration
  def change
    create_table :user_events do |t|
      t.references :user, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true
      t.boolean :status, default: false
      t.string :qr_image

      t.timestamps null: false
    end
  end
end
