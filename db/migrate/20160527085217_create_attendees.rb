class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.string :title
      t.string :company
      t.string :address
      t.string :website
      t.string :email
      t.string :phone
      t.string :mobile
      t.string :approval_status
      t.references :user, index: true, foreign_key: true
      t.references :event, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
