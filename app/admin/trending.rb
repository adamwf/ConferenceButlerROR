ActiveAdmin.register Trending do
	batch_action :destroy, false
	actions :all, :except => [:new, :destroy, :edit]
	config.sort_order = 'count_desc'

	index do
		selectable_column
		column :id 
		column "User Name" do |user|
     	 User.where(id: user.user_id).map(&:user_name) || "Created by Handel QR" 
    	end
	    column :count
	
	    column :created_at
	    column :updated_at
	    column "Actions" do |trend|
	      links = ''.html_safe
	      a do
         	links += link_to 'View',admin_trending_path(trend) 
          	links += '&nbsp;&nbsp;'.html_safe
          # links += link_to 'Edit',edit_admin_user_path(user)
          # links += '&nbsp;&nbsp;'.html_safe 
          # links += link_to 'Delete',admin_user_path(user), method: :delete,:data => { :confirm => 'Are you sure, you want to delete this User?' }
      		end
		end
	end
	
	show :title=> "Trending Profile Details" do
        attributes_table do
          row :id
          row :user
          row :count
          row :created_at 
          row :updated_at
        end 
	end
	action_item :view, only: :show do
    	link_to 'Back',admin_trendings_path
  	end
end
