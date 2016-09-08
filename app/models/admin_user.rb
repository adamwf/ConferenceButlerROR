class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  	devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

 	
  	validates :email, presence: true, uniqueness: true, length: { maximum: 40 },:format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,6})\z/i } 
  	validates :password, presence: true, length: { maximum: 30 }, on: :create
  	validates :password_confirmation, presence: true, length: { maximum: 30 }, on: :create
  	# validates :role, presence: true

end
