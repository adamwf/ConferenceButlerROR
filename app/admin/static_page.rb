ActiveAdmin.register StaticPage do
	batch_action :destroy, false

	permit_params :title, :content

	filter :title

 	index do 
		selectable_column
		column :id
		column :title
		column "Content" do |body|
      		truncate(body.content, omision: "...", length: 50)
    	end
	    column :created_at
    	column :updated_at
	    column "Actions" do |page|
	    	links = ''.html_safe
		    a do
			   	links += link_to 'View',admin_static_page_path(page) 
		        links += '&nbsp;&nbsp;'.html_safe
		        links += link_to 'Edit',edit_admin_static_page_path(page)
		        links += '&nbsp;&nbsp;'.html_safe 
		        links += link_to 'Delete',admin_static_page_path(page), method: :delete,:data => { :confirm => 'Are you sure, you want to delete this Static Page?' }
	    	end
	    end
  	end
  	action_item :view, only: :show do
    	link_to 'Back',admin_videos_path
  	end
end
