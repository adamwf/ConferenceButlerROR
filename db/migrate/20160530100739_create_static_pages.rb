class CreateStaticPages < ActiveRecord::Migration
  def change
    create_table :static_pages do |t|
      t.string :title, default: ""
      t.text :content, default: ""

      t.timestamps null: false
    end
  end
end
