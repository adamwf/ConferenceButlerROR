class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :assoc_id
      t.text :body
      t.string :image
      t.string :video
      t.boolean :read_status, default: true
      t.boolean :is_group, default: true
      t.references :room, index: true, foreign_key: true
      t.string :upload_type
      t.string :read_by,  default: [],    array: true
      t.string :created_timestamp

      t.timestamps null: false
    end
  end
end
