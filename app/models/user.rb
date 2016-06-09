class User < ActiveRecord::Base
  include Amistad::FriendModel 
  
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
  has_one  :social_code, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :invitations , through: :user_invitations
  has_many :user_invitations , dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :advertisements, dependent: :destroy
  has_many :activities, dependent: :destroy
   
  validates :user_name, presence: true, uniqueness: true, length: { maximum: 20 }#,:with => /^[A-Za-z\d_]+$/, :message => "Username can only be alphanumeric with no spaces."
  validates :email, presence: true, uniqueness: true, length: { maximum: 40 },:format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ } 
  validates :password, presence: true, length: { maximum: 20 }, on: :create
  validates :password_confirmation, presence: true, length: { maximum: 20 }, on: :create


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