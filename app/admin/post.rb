ActiveAdmin.register Post do
  menu parent: "Feeds"

	
	batch_action :destroy, false

  	scope :all, default: true
  	scope("Shown") { |post| post.where(status: true) }
  	scope("Hiden") { |post| post.where(status: false) }

  	filter :user
  	filter :title

 	permit_params :content, :user_id, :title

	index do 
		selectable_column
		column :id
		column :title
		column "Discription" do |body|
      		truncate(body.content, omision: "...", length: 50)
    	end
		column "User Name" do |user|
	      User.where(id: user.user_id).map(&:user_name) || "Created by Handel QR" 
	    end
	    column :created_at
    	column :updated_at
    	column "Status" do |post|
      		post.status ? '<i class = "status_tag yes"> Show </i>'.html_safe : '<i class = "status_tag no"> Hide </i>'.html_safe 
    	end
	    column "Actions" do |post|
		    links = ''.html_safe
		    a do
		        if (current_admin_user.role == 'super-admin')
		          if post.status?
		           links += link_to 'Hide',status_admin_posts_path(:post_id => post), method: :post,:data => { :confirm => 'Are you sure, you want to Hide this post?' }
		           links += '&nbsp;&nbsp;'.html_safe
		          else  
		           links += link_to 'Show',status_admin_posts_path(:post_id => post), method: :post,:data => { :confirm => 'Are you sure, you want to Show this post?' }
		           links += '&nbsp;&nbsp;'.html_safe
		          end
		        end
		        links += link_to 'View',admin_post_path(post) 
		        links += '&nbsp;&nbsp;'.html_safe
		        links += link_to 'Edit',edit_admin_post_path(post)
		        links += '&nbsp;&nbsp;'.html_safe 
		        links += link_to 'Delete',admin_post_path(post), method: :delete,:data => { :confirm => 'Are you sure, you want to delete this post?' }
		    end
	    end
  	end
	collection_action :status, method: :post do
	    post = Post.find(params[:post_id]) 
	    if post.status == false
         post.update_attributes(:status=> !post.status)
         redirect_to  admin_posts_path
      	else
         post.update_attributes(:status=> !post.status)
         redirect_to  admin_posts_path
      	end
	end


	form do |f|
	    f.inputs "Advertisement" do
	      f.input :user, :as => :select, :collection => User.where(role: ['manager', "organizer"])
	      f.input :title
	      f.input :content
	    end
	    f.actions
	end

	show :title=> "Post Details" do
	    attributes_table do
	      row :id
	      row :title
	      row :user_id
	      row :content
	      row :created_at 
	      row :updated_at
	    end 	
  	end
  	action_item :view, only: :show do
    	link_to 'Back',admin_videos_path
  	end
end
