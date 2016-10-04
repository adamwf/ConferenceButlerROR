class Webservices::RequestApisController < ApplicationController
	before_filter :find_user,except: []
	before_filter :find_friend,except: [:pending_request, :contact_list]
    before_filter :authentication
    
	def send_request
		if @user.friend_with?(@friend)
			render_message 500, "User already present in your friend list."
		elsif  @user.invited_by?(@friend) or @friend.invited_by?(@user)
			render_message 500, "User already invited by you."
		else
			@user.invite(@friend)
			alert = @user.user_name + ' ' + 'sends a request to you.'
		    activity = @friend.activities.create(activity_type: 'friend_request',item_id: @user.id,item_type: 'User', user_id: @user.id, message: alert)    		
		    PushWorker.perform_async(@friend.id,alert,@user.id,'User',@user.user_name,activity.id)
		    if @trend = Trending.find_by_user_id(@friend.id)
				@trend.update_attributes(count: @trend.count+1)
			else 
				@trend = Trending.create(user_id: @friend.id, count: 1)
			end	
		  	# UserMailer.send_friend_request_mail(friend.email).deliver
			render_message 200, "You invited #{@friend.first_name} successfully."
		end
	end

	def accept_request
		if @friend.invited?(@user) 
			if !@user.friend_with?(@friend)
				@user.approve(@friend)
				@user.friendships.find_by(friend_id: @friend.id).update_attributes(keyword: params[:user][:keyword])
				alert = @user.user_name+' '+'accepted your request.'
	 			activity = @friend.activities.find_or_create_by(activity_type: 'friend_request',item_id: @user.id,item_type: 'User', user_id: @user.id, message: alert)
			    PushWorker.perform_async(@friend.id,alert,@user.id,'User',@user.user_name,activity.id)
				render_message 200, "You approved #{@friend.first_name}'s request successfully."
			else
				render_message 500, "#{@friend.user_name} is already in your friend list."	
			end
		else
			render_message 500, "You don't have any friend request."
		end
	end

	def reject_request
		if @friend
			@user.remove_friendship(@friend)
			alert = @user.user_name+' '+'rejected your request.'
	 		activity = @friend.activities.find_or_create_by(activity_type: 'friend_request',item_id: @user.id,item_type: 'User', user_id: @user.id, message: alert)
		    PushWorker.perform_async(@friend.id,alert,@user.id,'User',@user.user_name,activity.id)
			render_message 200, "You rejected #{@friend.first_name}'s request successfully."
		else
			render_message 500, "You don't have any friend request."
		end
	end

	def pending_request
		render :json => {:responseCode => 200,:responseMessage => "Pending invitations fetched successfully.",:pending_invitations => @user.pending_invited_by.order("created_at desc").paginate(:page => params[:page], :per_page => 10).map{|user| user.attributes.merge(:mutual_friend_count => user.common_friends_with(@user).count, :image =>  user.image.url)}}
	end
	
	def contact_list
		if params[:user][:keyword].eql?("")
			render :json => {:responseCode => 200,:responseMessage => "Your contact(GAB) list fetched successfully.",:contacts_list => @user.friends.order("#{params[:sort]} asc").paginate(:page => params[:page], :per_page => 10).map{|user| user.attributes.merge(:mutual_friend_count => user.common_friends_with(@user).count, :image =>  user.image.url, :social_logins => user.social_logins.map(&:user_name))}}
		else
		   friends = @user.friendships.where("keyword LIKE ?", "%#{params[:user][:keyword]}%") & @user.friendships.where(pending: false)
		    @friends = friends.map{|key| key.friend}		   	
		   	render :json => {:responseCode => 200,:responseMessage => "Your contact(GAB) list fetched successfully.",:contacts_list => @friends.sort_by {|friend| friend[:first_name]}.map{|user| user.attributes.merge(:mutual_friend_count => user.common_friends_with(@user).count, :image =>  user.image.url, :social_logins => user.social_logins.map(&:user_name))}}
		end
	end

	# private

	# def find_user
	# 	if params[:user][:user_id]
	# 		@user = User.find_by_id(params[:user][:user_id])
	# 	    unless @user
	# 	     render_message 500, "Oops! User not found."
	# 	    end
	# 	else
	# 		render_message 500, "Sorry! You are not an authenticated user."
	#     end
 #  	end

 #  	def find_friend
	# 	if params[:user][:friend_id]
	# 		@friend = User.find_by_id(params[:user][:friend_id])
	# 	    unless @friend
	# 	     render_message 500, "Oops! Friend User not found."
	# 	    end
	# 	else
	# 		render_message 500, "Sorry! You are not an authenticated user."
	#     end
 #  	end
end
