class GroupsController < ApplicationController

	before_filter :find_user,except: [:update,:mute_group]

	def create
	  member_id= (params[:member_ids])
		return render_message 500, "Please select atleast one member." if !member_id or member_id.length < 1
		@group = @user.groups.build(group_name: params[:group_name], group_image: params[:group_image])
		members = User.where(id: member_id)
		if @group.save! 
			members.each do |member|
        group = @group.group_memberships.create!(user_id: member.id)
        alert = @user.user_name + ' ' + 'added you in a group.'
        activity = member.activities.create(activity_type: 'Added in group',item_id: @user.id,item_type: 'Group Admin', user_id: @user.id, message: alert)        
        PushWorker.perform_async(member.id,alert,@user.id,'Group Admin',@user.user_name,activity.id)
        if @trend = Trending.find_by_user_id(member.id)
          @trend.update_attributes(count: @trend.count+1)
        else 
          @trend = Trending.create(user_id: member.id, count: 1)
        end 
    	end
      	render :json => { 
          :response_code => 200,
          :response_message => "Group Created successfully.",
          :group_id => @group.as_json(only: [:id,:group_name , :group_image])
          # :group_list => array.sort_by{|e| e[:tstamp].to_i}.reverse  
        }  
		else
			render_message 500, @group.errors.full_messages.first.capitalize.to_s.gsub('_',' ') + "."
		end
	end

	def group_list
	  count_1= group_chat.pluck(:read_by).size - group_chat.pluck(:read_by).flatten.count(@user.id.to_s)
	  individual_chat =  Message.where("assoc_id = ? and is_group = ?", @user.id , false)
	  count_2 = individual_chat.pluck(:read_by).size - individual_chat.pluck(:read_by).flatten.count(@user.id.to_s)
		group_created = @user.groups
		group_joined=Group.where(id: GroupMembership.where(user_id: @user.id).pluck(:group_id))
    list =  (group_created + group_joined).uniq
    array= Array.new
    if list
      list.each do |group|
      	# message = Message.where("((sender_id = ? and assoc_id = ? ) or (sender_id = ? and assoc_id = ? ) and ( is_group = ? ))", @user.id,group.id,group.id, @user.id , true)#.order(:tstamp)
      	message = Message.where(" (assoc_id = ? ) and ( is_group = ? )", group.id , true)#.order(:tstamp)
        last_message = message.last
        if message	       
          unread_count = message.pluck(:read_by).size -  message.pluck(:read_by).flatten.count(@user.id.to_s)
        end
      	unread_messages = unread_count
      	group = group.as_json(only: [:id,:group_name]).merge(group_image: group.group_image.url, 
         is_owner: Group.find_by(id: group.id,
         user_id: @user.id).present? ? true : false ,
         group_members:  User.where(id: group.group_memberships.pluck(:user_id)).as_json(only: [:id , :username , :photo]) ,
         message_id: last_message.present? ? last_message.id : 0 ,
         message: last_message.present? ? last_message.body.nil? ? "*Image-Icon*" : last_message.body : "" , 
         created_timestamp:  last_message.present? ? last_message.created_timestamp.nil? ? "0000000000" : last_message.created_timestamp : "0000000000" , 
         unread_messages: unread_messages
        )
      	array << group
      end
    else
      array = []
    end
    render :json => { 
      :response_code => 200,
      :response_message => "List of groups.",
      :total_unread => count_1+count_2,
      # :group_list =>  (group_created+group_joined).map{|group| group.attributes.merge(id: group.id ,group_name:group.group_name ,group_image: group.group_image.url,is_owner: Group.find_by(id: group.id,user_id: @user.id).present? ? true : false ,group_members:  User.where(id: group.group_memberships.pluck(:user_id)).as_json(only: [:id,:username,:photo]))},
      :group_list => array.sort_by{|e| e[:created_timestamp].to_i}.reverse  
    }    
	end
	
	def group_destroy
		group= Group.find_by(id: params[:group_id],user_id: @user.id)
    if group.present?
      group.destroy
      render_message 200, "Group deleted successfully."
    else
      group = GroupMembership.find_by(group_id: params[:group_id],user_id: @user.id)
      if group.present?
	       group.destroy
         render :json => { 
           :response_code => 200,
           :response_message => "Leaved Group successfully."
         }  
      else
    		render_message 500, "Something went wrong."
 	    end
    end
	end

	def mute_group
    member = GroupMembership.find_by(group_id: params[:group_id], user_id: params[:member_id]) 
    if member
    		member.update_attributes(is_mute: true)
    		render_message 200, "Group muted successfully for this user."
  	else
   	   render_message 500, "User not present in group."
  	end
  end
  
	# def update
 #    member_id=JSON.parse(params[:member_ids]).split("\"").flatten
 #    group = Group.find_by(id: params[:group_id],user_id: params[:id])
 #    return render_message 500, "You are not allowed to edit the group." if !group.present?
 #    return render_message 500, "Please select atleast one member." if !member_id or member_id.length < 1
 #    group.update(group_name: params[:group_name],group_image: params[:group_image]) 
 #    already_present_users=group.group_memberships.pluck(:user_id)	          

 #    or_operation = (already_present_users | member_id)
 #    removed_user =(or_operation-member_id) 
 #    GroupMembership.where(user_id: removed_user).destroy_all if removed_user.present?
 #    and_operation = (already_present_users & member_id)
 #    added_user=(member_id-and_operation)
       
 #    if !added_user.blank?
 #       added_user.each do |member|
 #      		group_memberships=group.group_memberships.create(user_id: member)
 #       end
 #    end
 #    render :json => { 
 #      :response_code => 200,
 #      :group_id => params[:group_id],
 #      :member_id => member_id,
 #      :users => User.where("id IN (?)", member_id).as_json(only: [:id,:username,:photo,:photo_link]),
 #      :response_message => "Group updated successfully."
 #    }  
 #  end

	def search_group
	  group_created = @user.groups
	  group_joined = Group.where(id: GroupMembership.where(user_id: @user.id).pluck(:group_id))
		render :json => { 
      :response_code => 200,
      :response_message => "list of groups.",
      # :group_list =>  (group_created+group_joined).map{|group| group.attributes.merge(id: group.id ,group_name: group.group_name ,group_image: group.group_image.url,is_owner: Group.find_by(id: group.id,user_id: @user.id).present? ? true : false)},
      :group_list => Group.where("id IN (?) and group_name ILIKE ? ", (group_created+group_joined).map{|x| x.id} , "#{params[:search]}%").as_json(only: [:id , :group_name , :group_image]) 
    } 
  end

  private
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
