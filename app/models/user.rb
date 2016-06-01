class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :image, ImageUploader

  geocoded_by :address
  after_validation :geocode  

  has_many :devices, dependent: :destroy
  has_many :social_logins, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_one :social_code, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :invitations , through: :user_invitations
  has_many :user_invitations , dependent: :destroy

                   
  def self.image_data(data)
    return nil unless data
    CarrierStringIO.new(Base64.decode64(data)) 
  end

  class CarrierStringIO < StringIO
    def original_filename
      # the real name does not matter
      "photo.jpeg"
    end

    def content_type
      # this should reflect real content type, but for this example it's ok
      "image/jpeg"
    end 
  end

  def to_s
    "#{user_name}"
  end
end