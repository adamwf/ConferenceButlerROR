class CreateOtpInfos < ActiveRecord::Migration
  def change
    create_table :otp_infos do |t|
      t.string :email
      t.string :otp

      t.timestamps null: false
    end
  end
end
