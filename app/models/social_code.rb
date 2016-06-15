require 'rqrcode_png'
class SocialCode < ActiveRecord::Base
  belongs_to :user
  has_many :social_logins
	

 	def self.generate_qr
		random_name = SecureRandom.hex(8)
		p "--12---------#{random_name.inspect}-------------------------"
		qr = RQRCode::QRCode.new(random_name, :size => 20)
		p "--13---------#{qr.inspect}-------------------------"
		png = qr.to_img  
		p "--14---------#{png.inspect}-------------------------"                                           # returns an instance of ChunkyPNG
		File.open(Rails.root.join("public/#{random_name}.png"), 'wb'){|f| f.write png }
		p "--15---------#{png.inspect}-------------------------"
		image = Cloudinary::Uploader.upload(Rails.root.join("public/#{random_name}.png"))
		p "--16---------#{image.inspect}-------------------------"
		File.delete("./public/#{random_name}.png")
		p "--17---------#{image.inspect}-------------------------"
		p image.as_json(only: ["public_id", "url"])
	end
end
