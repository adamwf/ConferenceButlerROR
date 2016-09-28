class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :sender_id
      t.integer :assoc_id
      t.boolean :is_group, default: false

      t.timestamps null: false
    end
  end
end
