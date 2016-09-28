class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :last_seen
      t.string :current_status
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
