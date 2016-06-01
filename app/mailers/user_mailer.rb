class UserMailer < ApplicationMailer

    def send_otp(user) 
    	@user = user   	
    	p"-------------#{@user.inspect}--------------"
    	mail(:to => @user.email, :subject => "World-Fax - OTP Confirmation Email")          
    end 

    def account_confirmation(admin_user)
    	@user = admin_user
    	p"==================#{@user.inspect}======================="
    	mail(:to => @user.email, :subject => "World-Fax - Account Confirmation Email")
    end     
end
