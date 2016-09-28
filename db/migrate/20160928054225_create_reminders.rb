class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.references :user, index: true, foreign_key: true
      t.boolean :status,default: false
      t.string :delay_time

      t.timestamps null: false
    end
  end
end
