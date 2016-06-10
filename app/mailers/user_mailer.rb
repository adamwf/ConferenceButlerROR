class UserMailer < ApplicationMailer

	def send_otp(otp) 
    	@otp = otp   	
    	p"-------------#{@otp.inspect}--------------"
    	mail(:to => @otp.email, :subject => "Handle-QR - OTP Confirmation Email")          
    end 

    def signup_confirmation(user) 
    	@user = user   	
    	p"-------------#{@user.inspect}--------------"
    	mail(:to => @user.email, :subject => "Handle-QR - Signup Confirmation Email")          
    end 

    def password_reset(user)
        @user = user 
        mail(:to => user.email, :subject => "Handle-QR - Password Reset Instructions") 
    end
end
