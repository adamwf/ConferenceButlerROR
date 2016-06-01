class CreateSocialCodes < ActiveRecord::Migration
  def change
    create_table :social_codes do |t|
      t.string :code
      t.string :image
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
