class UserMailer < ApplicationMailer

	def send_otp(user) 
    	@user = user      
    	mail(:to => @user.email, :subject => "Handle-QR - OTP Confirmation Email")    
    end 

    def verify_otp(user, email) 
        @user = user  
        @email = email    
        mail(:to => email, :subject => "Handle-QR - OTP Confirmation Email")    
    end

    def signup_confirmation(user) 
    	@user = user   	
    	mail(:to => @user.email, :subject => "Conference-Butler - Signup Confirmation Email")          
    end 

    def password_reset(user)
        @user = user 
        mail(:to => user.email, :subject => "Handle-QR - Password Reset Instructions") 
    end

    def forget_password(user)
        @user = user 
        mail(:to => @user.email, :subject => "Forward-Info - Password Reset Instructions") 
    end

    def account_confirmation(user, current_user) 
        @user = user 
        @current_user = current_user   
        mail(:to => @user.email, :subject => "Conference-Butler - Account Confirmation Email")          
    end 
end
