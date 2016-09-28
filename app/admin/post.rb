ActiveAdmin.register Post do
  menu parent: "Curate Feeds"

	
   	batch_action :destroy, false

  	scope :all, default: true
  	scope("Published") { |post| post.where(status: true) }
  	scope("Not Published") { |post| post.where(status: false) }
  	scope("Home Posts") { |post| post.where(category: "home") }
    scope("Event Posts") { |post| post.where(category: "event") }
    scope("Discover Posts") { |post| post.where(category: "discover") }
    scope("Trending Posts") { |post| post.where(category: "trending") }
    scope("Shop Posts") { |post| post.where(category: "shop") }

  	filter :user
  	filter :category_cont , :as => :string , :label => "Category"
  	filter :title_cont , :as => :string , :label => "Post Title"

 	permit_params :content, :user_id, :title, :category

	index do 
		selectable_column
		# column :id
		column "Title" do |body|
      		truncate(body.title, omision: "...", length: 10)
    	end
		column "Description" do |body|
      		truncate(body.content, omision: "...", length: 50)
    	end
		# column "User Name" do |user|
	 #      User.where(id: user.user_id).map(&:user_name) || "Created by Handel QR" 
	 #    end
	    # column :created_at
    	# column :updated_at
    	column :category
    	column "Status" do |post|
      		post.status ? '<i class = "status_tag yes"> Published </i>'.html_safe : '<i class = "status_tag no"> Do Not Published </i>'.html_safe 
    	end
	    column "Actions" do |post|
		    links = ''.html_safe
		    a do
		        if (current_admin_user.role == 'super-admin')
		          if post.status?
		           links += link_to 'Do Not Published',status_admin_posts_path(:post_id => post), method: :post,:data => { :confirm => 'Are you sure, you want to Hide this post?' }
		           links += '&nbsp;&nbsp;'.html_safe
		          else  
		           links += link_to 'Published',status_admin_posts_path(:post_id => post), method: :post,:data => { :confirm => 'Are you sure, you want to Show this post?' }
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
	      f.input :category, :as => :select, :collection =>  ['home', "event", 'feeds', 'discover','shop', 'trending']
	      f.input :content, label: "Description"
	    end
	    f.actions
	end

	show :title=> "Post Details" do
	    attributes_table do
	      row :id
	      row :title
	      row :user_id
	      row :category
	      row "Description" do 
	      	post.content
	      end
	      row :created_at 
	      row :updated_at
	    end 	
  	end
  	action_item :view, only: :show do
    	link_to 'Back',admin_posts_path
  	end
end
