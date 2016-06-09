class Webservices::RequestApisController < ApplicationController
	before_filter :find_user,except: []
	before_filter :find_friend,except: [:pending_request]

	def send_request
		if @user.friend_with?(@friend)
			render :json => {:responseCode => 500,:responseMessage => "User already present in your friend list."}
		elsif  @user.invited_by?(@friend) or @friend.invited_by?(@user)
			render :json => {:responseCode => 500,:responseMessage => "User already invited by you."}
		else
			@user.invite(@friend)
			alert = @user.user_name + ' ' + 'sends a request to you.'
		    activity = @friend.activities.create(activity_type: 'friend_request',item_id: @user.id,item_type: 'User', user_id: @user.id, message: alert)    		
		    PushWorker.perform_async(@friend.id,alert,@user.id,'User',@user.user_name,activity.id)
		  	# UserMailer.send_friend_request_mail(friend.email).deliver
			render :json => {:responseCode => 200,:responseMessage => "You invited #{@friend.first_name} successfully."}
		end
	end
	
	def accept_request
		if @friend.invited?(@user)
			if !@user.friend_with?(@friend)
				@user.approve(@friend)
				alert = @user.user_name+' '+'accepted your request.'
	 			activity = @friend.activities.find_or_create_by(activity_type: 'friend_request',item_id: @user.id,item_type: 'User', user_id: @user.id, message: alert)
			    PushWorker.perform_async(@friend.id,alert,@user.id,'User',@user.user_name,activity.id)
				render :json => {:responseCode => 200,:responseMessage => "You approved #{@friend.first_name}'s request successfully."}
			else
				render :json => {:responseCode => 500,:responseMessage => "#{@friend.user_name} is already in your friend list."}	
			end
		else
			render :json => {:responseCode => 500,:responseMessage => "You don't have any friend request."}
		end
	end

	def reject_request
		if @friend
			@user.remove_friendship(@friend)
			alert = @user.user_name+' '+'rejected your request.'
	 		activity = @friend.activities.find_or_create_by(activity_type: 'friend_request',item_id: @user.id,item_type: 'User', user_id: @user.id, message: alert)
		    PushWorker.perform_async(@friend.id,alert,@user.id,'User',@user.user_name,activity.id)
			render :json => {:responseCode => 200,:responseMessage => "You rejected #{@friend.first_name}'s request successfully."}
		else
			render :json => {:responseCode => 500,:responseMessage => "You don't have any friend request."}
		end
	end

	def pending_request
		render :json => {:response_code => 200,:response_message => "Pending invitations fetched successfully.",:invitaions => @user.pending_invited_by.map{|user| user.attributes.merge(:mutual_friend_count => user.common_friends_with(@user).count, :image =>  user.image.url)}
            }
	end
	

	private

	def find_user
		if params[:user][:user_id]
			@user = User.find_by_id(params[:user][:user_id])
		    unless @user
		     render :json =>  {:responseCode => 500,:responseMessage => "Oops! User not found."}
		    end
		else
			render :json =>  {:responseCode => 500,:responseMessage => "Sorry! You are not an authenticated user."}
	    end
  	end

  	def find_friend
		if params[:user][:friend_id]
			@friend = User.find_by_id(params[:user][:friend_id])
		    unless @friend
		     render :json =>  {:responseCode => 500,:responseMessage => "Oops! Friend User not found."}
		    end
		else
			render :json =>  {:responseCode => 500,:responseMessage => "Sorry! You are not an authenticated user."}
	    end
  	end
end
