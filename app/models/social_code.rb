class SocialCode < ActiveRecord::Base
  belongs_to :user
  has_many :social_logins
	require 'rqrcode_png'


 	def self.generate_qr
		random_name = SecureRandom.hex(8)
		qr = RQRCode::QRCode.new(random_name, :size => 20)
		png = qr.to_img                                             # returns an instance of ChunkyPNG
		File.open(Rails.root.join("public/QRCodes/#{random_name}.png"), 'wb'){|f| f.write png }
		image = Cloudinary::Uploader.upload(Rails.root.join("public/QRCodes/#{random_name}.png"))
		File.delete("./public/QRCodes/#{random_name}.png")
		p image.as_json(only: ["public_id", "url"])
	end
end
