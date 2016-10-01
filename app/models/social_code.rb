require 'rqrcode_png'
class SocialCode < ActiveRecord::Base
  belongs_to :user
  has_many :social_logins
	

 	def self.generate_qr
		random_name = SecureRandom.hex(8)
		qr = RQRCode::QRCode.new(random_name, :size => 10)
		png = qr.as_png(color: '30c1db')
		# png = svg.to_img  
		File.open(Rails.root.join("public/#{random_name}.png"), 'wb'){|f| f.write png }
		image = Cloudinary::Uploader.upload(Rails.root.join("public/#{random_name}.png"))
		File.delete("./public/#{random_name}.png")
		p image.as_json(only: ["public_id", "url"])
	end
end
