# Migration responsible for creating a table with activities
class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string   :activity_type
      t.integer  :item_id
      t.string   :item_type
      t.text     :message,       default: ""
      t.integer  :shared_id
      t.boolean  :read ,         default: false
      t.references :user, index: true

      t.timestamps
    end
  end
end
