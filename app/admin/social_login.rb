ActiveAdmin.register SocialLogin do
	menu parent: "Social Profiles"

	batch_action :destroy, false
	actions :all, :except => [:new, :destroy, :edit]

	filter :user
	filter :provider
	filter :user_name

	index do
		selectable_column
		# column :id 
		column "Personal User Name" do |user|
     	 User.where(id: user.user_id).map(&:user_name) || "Created by Handel QR" 
    	end
	    column :provider
	    column :user_name
	    column :created_at
	    column :updated_at
	    column "Actions" do |login|
	      links = ''.html_safe
	      a do
         	links += link_to 'View',admin_social_login_path(login) 
          	links += '&nbsp;&nbsp;'.html_safe
          # links += link_to 'Edit',edit_admin_user_path(user)
          # links += '&nbsp;&nbsp;'.html_safe 
          # links += link_to 'Delete',admin_user_path(user), method: :delete,:data => { :confirm => 'Are you sure, you want to delete this User?' }
      		end
		end
	end

	show :title=> "Social Login Details" do
	    attributes_table do
	      row :id
	      row :user
	      row :provider
	      row :user_name
	      row :created_at 
	      row :updated_at
	      row 'Social Code' do
	      	@social = User.find_by_id(social_login.user_id)
	      	image_tag(@social.social_code.image)
	      end
	    end 	
	end
	action_item :view, only: :show do
    	link_to 'Back',admin_social_logins_path
  	end
end
