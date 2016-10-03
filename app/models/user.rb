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
  has_one  :social_code, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :invitations , through: :user_invitations
  has_many :user_invitations , dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :advertisements, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_one  :trending, dependent: :destroy
  has_many :profile_views, dependent: :destroy
  has_one  :reminder, dependent: :destroy
  has_many :notifications, :as => :notifiable, :dependent => :destroy 
  has_many :groups,:dependent => :destroy
  has_many :group_memberships, :through => :groups
  has_many :send_messages,:class_name => 'Message',:foreign_key => 'sender_id',:dependent => :destroy
  has_many :recieved_messages, -> { where(is_group: false) },:class_name => 'Message',:foreign_key => 'assoc_id',:dependent => :destroy
  has_many :group_messages, -> { where(is_group: true) },:class_name => 'Message',:foreign_key => 'assoc_id',:dependent => :destroy


  # validates :user_name, presence: true, uniqueness: true, length: { maximum: 20 },:format => {:with => /\A(^[A-Za-z][A-Za-z0-9.@_-]*$)\z/}
  validates :email, presence: true, uniqueness: true, length: { maximum: 40 },:format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,6})\z/i } 
  validates :password, presence: true, length: { maximum: 20 }, on: :create
  validates :password_confirmation, presence: true, length: { maximum: 20 }, on: :create
  validates :other_info, length: { maximum: 300}


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

  def self.send_password_reset(user)
    user.update_attributes(:password => SecureRandom.hex(4)) 
    UserMailer.password_reset(user).deliver_now
  end

  def to_s
    "#{user_name}"
  end

  def generate_auth_token
    begin
      self.access_token = SecureRandom.hex
    end while User.where(access_token: access_token).exists?
  end
end