class MessagesController < ApplicationController
	before_filter :find_user,only: [:user_status_for_chat,:get_user_status,:unread_messages]


	def notify_user
	   if params[:is_group]
		   sender_id = params[:sender_id].to_i
	       self_id = [sender_id]
		   group = Group.find_by_id(params[:assoc_id])
		   member_ids =  (Group.where(id: params[:assoc_id]).first.group_memberships.pluck(:user_id) << group.user_id )- self_id
	       subject = "You have got a new message in group #{group.group_name}."
		   content = "MESSAGE/#{params[:assoc_id]}/#{sender_id}/true"

	        member_ids.each do |user_id|
	        	user = User.find_by_id(user_id)
		           user.devices.each do |device|
	                      ChatNotificationWorker.perform_async(device.device_id,device.device_type, subject,content,params[:assoc_id],params[:sender_id],params[:is_group]) if user.notification_for_group_chat
		           end
	          notification =  Notification.create(:user_id => sender_id,:receiver_id => user_id ,:noti_type => content ,:subject=> subject,:pending=> true)
	        end
	        render_message 200, "Notification Sent to Group Members Sucessfully"
	   else
	  	   sender_id = params[:sender_id]
	       user = User.find_by_id(params[:assoc_id])  
           subject = "You have got a new message from #{User.find_by_id(sender_id).username}"
	       content = "MESSAGE/#{params[:assoc_id]}/#{sender_id}/false"
           Notification.create(:user_id => sender_id,:receiver_id => user.id ,:noti_type => content ,:subject=> subject,:pending=> true) 
           if user.chat_notification == true
	           user.devices.each do |device|
                   ChatNotificationWorker.perform_async(device.device_id,device.device_type, subject,content,params[:assoc_id],params[:sender_id],params[:is_group]) if user.notification_for_direct_chat
	           end
		    end
	       render_message 200, "Notification Sent User Sucessfully"
	   end
    end

	def user_status_for_chat
        if @user.update_attributes(user_status_for_chat_params)
      	    if @user.show_online_status == true or @user.notification_for_direct_chat == true or @user.notification_for_group_chat==true
                @user.update_attribute(:chat_notification,true)                         
            elsif @user.show_online_status == false and @user.notification_for_direct_chat == false and @user.notification_for_group_chat==false
                @user.update_attribute(:chat_notification,false)
            end
            render :json => { 
	            :response_code => 200,
	            :response_message => "Your chat status updated successfully.",
            }    
        else
	        render_message 500, @user.errors.full_messages.first.capitalize.to_s.gsub('_',' ') + "."
	    end
	end

	def get_user_status
	 	render :json => { 
	 		:response_code => 200,
	        :response_message => "Your chat status updated successfully.",
	        :show_online_status => @user.show_online_status,
			:notification_for_direct_chat => @user.notification_for_direct_chat,
			:notification_for_group_chat => @user.notification_for_group_chat
	    }  
	end

	def attach_image
		message = params[:message]
        @message = Message.create(:sender_id => params[:sender_id],:assoc_id => params[:assoc_id],:body => params[:body],:image => params[:image] ,:is_group => params[:is_group],:upload_type => params[:upload_type], :room_id => params[:room_id], :tstamp => DateTime.now.to_i , read_by: [params[:sender_id]])
        render :json => {:response_code  => 200,
        :response_message => "Image added successfuly.",:body => @message.image.url , :message => @message  }		
	end

	def update_status
		status = params[:status]
		@user = User.find(status[:user_id])
		if @user.status.present?
		  @user.status.update_attributes(current_status: "online") 
		else
			@status = @user.build_status(last_seen_timestamp: DateTime.current)
			@status.save
		end
		render nothing: true
	end


	#ONE TO ONE CHAT HISTORY START

    def get_chats
 	p"------get_group_chat----#{params.inspect}-----------"
		@sender = User.find_by_id(params[:sender_id])
		@reciever = User.find_by_id(params[:assoc_id])
        @room = Room.where("(sender_id = ? and assoc_id = ? and is_group = ?) or (sender_id = ? and assoc_id = ? and is_group = ?) ", @sender.id,params[:assoc_id],false ,params[:assoc_id], @sender.id , false).first
		    if @room.nil?
		       @room = Room.create(:sender_id => params[:sender_id],:assoc_id => params[:assoc_id] )
		    end
        @chats = Message.where("((sender_id = ? and assoc_id = ? ) or (sender_id = ? and assoc_id = ? ))", @sender.id,params[:assoc_id],params[:assoc_id], @sender.id).order(:tstamp)
		array = Array.new
	    @chats.each do |chat|
		    read_by = chat.read_by
		    read_by << params[:sender_id].to_s unless read_by.include?(params[:sender_id].to_s)	
		    chat.update(read_by: read_by)
		    hash = {}
		    hash[:id] = chat.id
	        chat.body == nil ? hash[:body] = chat.image.url : hash[:body] = chat.body
		    hash[:read_status] = chat.read_status
		    hash[:upload_type] =   chat.upload_type
	        hash[:created_timestamp] = chat.tstamp
		    hash[:is_user_sender] = (chat.sender_id == @sender.id )? true :false
		  	array << hash
        end
        if @reciever.show_online_status
		  status = @reciever.status.current_status 
        else
          status = false
        end
		render :json => {
			:response_code  => 200,
	        :response_message => "Chats fetched Successfuly.",
	        :user_img => @sender.photo_link.nil? ? @sender.photo_url : @sender.photo_link ,
	        :name => @sender.username,
	        :room_id => @room.id,
	        :current_status => status ,
		    :user_info => array
	    }
    end

	######GROUP CHAT HISTORY START
	def get_group_chat
	 	p"------get_group_chat----#{params.inspect}-----------"
 		@sender = User.find_by(id: params[:sender_id])
		@group = Group.find_by(id: params[:assoc_id])
		@group_owner = @group.user_id
		group_member_ids = @group.group_memberships.pluck(:user_id) << @group_owner
	    if @group.present?
		  # @room = Room.where("(sender_id = ? and assoc_id = ? and is_group = ?) or (sender_id = ? and assoc_id = ? and is_group = ?) ", @sender.id,@group.id,true,@group.id,@sender.id,true).first
			@room = Room.where("(assoc_id = ? and is_group = ?) ", @group.id,true).first
	     	if @room.nil?
			   @room = Room.create(:sender_id => params[:sender_id],:assoc_id => @group.id, :is_group => TRUE )
			end
	    	@chats = Message.where("(assoc_id = ? and is_group = ? )",@group.id, true).order(:created_timestamp)
		    array = Array.new
		    @chats.each do |chat|
		        read_by = chat.read_by
			    read_by << params[:sender_id].to_s unless read_by.include?(params[:sender_id].to_s)	
			    chat.update(read_by: read_by)
			    hash = {}
			    hash[:id] = chat.id
			    chat.body == nil ? hash[:body] = chat.image.url : hash[:body] = chat.body
			    hash[:username] = User.find_by_id(chat.sender_id).username
			    hash[:upload_type] =   chat.upload_type		  
		 		p "=============UPLOAD TYPE==========#{chat.upload_type.inspect}=================================="
			    hash[:is_user_sender] = (chat.sender_id == @sender.id )? true :false
			    hash[:created_timestamp] = chat.tstamp
			    array << hash
			end
		    render :json => {:response_code  => 200,
	           :response_message => "Chats fetched Successfuly.",
	           :room_id => @room.id,
			   :group_member_ids => group_member_ids,
			   :group_img => @group.group_image,
	           :name => @group.group_name,
	           :user_info => array					        
	        }
       else
      		render_message 500, "Group does not exist."
       end
    end

	def unread_messages
		group_chat = Message.where("assoc_id IN (?) and is_group = ? " ,  (@user.groups.pluck(:id) + Group.where(id: GroupMembership.where(user_id: @user.id).pluck(:group_id))).uniq , true)
		count_1 = group_chat.pluck(:read_by).size - group_chat.pluck(:read_by).flatten.count(@user.id.to_s)
		individual_chat =  Message.where("assoc_id = ? and is_group = ?", @user.id , false)
		count_2 = individual_chat.pluck(:read_by).size - individual_chat.pluck(:read_by).flatten.count(@user.id.to_s)
		render :json => {:response_code  => 200,
	        :response_message => "Unread Messages Fetched Successfully.",:count => count_1+count_2  
	    }
	end


 	private
	  
	def user_status_for_chat_params
	  params.permit(:created_timestamp,:show_online_status,:notification_for_direct_chat,:notification_for_group_chat,:image,:room_id , :upload_type, :video)
	end

	def find_user
		if params[:user][:user_id]
			@user = User.find_by_id(params[:user][:user_id])
		    unless @user
		     render_message 500,"Oops! User not found."
		    end
		else
			render_message 500, "Sorry! You are not an authenticated user."
	    end
  	end
end
