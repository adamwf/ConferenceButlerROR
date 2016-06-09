ActiveAdmin.register Advertisement do
batch_action :destroy, false

permit_params :image, :user_id, :title, :discription, :priority


# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  scope :all, default: true
  scope("Shown") { |ads| ads.where(status: true) }
  scope("Hiden") { |ads| ads.where(status: false) }

  filter :user
  filter :title
# permit_params :list, :of, :attributes, :on, :model
	index do
		selectable_column
		column :id 
		column "User Name" do |user|
     	 User.where(id: user.user_id).map(&:user_name) || "Created by Handel QR" 
    	end
		column :title
		column "Image" do |add|
	      image_tag(add.image.url,:width => 50, :height => 50)
	    end
	    column "Discription" do |body|
        	truncate(body.discription, omision: "...", length: 50)
      	end
	    column :priority, sortable: :priority
	    column :created_at
	    column :updated_at
	   	column "Status" do |advertisement|
      		advertisement.status ? '<i class = "status_tag yes"> Show </i>'.html_safe : '<i class = "status_tag no"> Hide </i>'.html_safe 
		end
	    # actions
	    column "Actions" do |advertisement|
		    links = ''.html_safe
		    a do
		        if (current_admin_user.role == 'super-admin')
		          if advertisement.status?
		           links += link_to 'Hide',status_admin_advertisements_path(:advertisement_id => advertisement), method: :post,:data => { :confirm => 'Are you sure, you want to Hide this advertisement?' }
		           links += '&nbsp;&nbsp;'.html_safe
		          else  
		           links += link_to 'Show',status_admin_advertisements_path(:advertisement_id => advertisement), method: :post,:data => { :confirm => 'Are you sure, you want to Show this advertisement?' }
		           links += '&nbsp;&nbsp;'.html_safe
		          end

		          advertisement.priority?
		           links += link_to 'Up',uppriority_admin_advertisements_path(:advertisement_id => advertisement), method: :post,:data => { :confirm => 'Are you sure, you want to move up this advertisement?' }
		           links += '&nbsp;&nbsp;'.html_safe
 
		           links += link_to 'Down',downpriority_admin_advertisements_path(:advertisement_id => advertisement), method: :post,:data => { :confirm => 'Are you sure, you want to move down this advertisement?' }
		           links += '&nbsp;&nbsp;'.html_safe
		         
		        end
		        links += link_to 'View',admin_advertisement_path(advertisement) 
		        links += '&nbsp;&nbsp;'.html_safe
		        links += link_to 'Edit',edit_admin_advertisement_path(advertisement)
		        links += '&nbsp;&nbsp;'.html_safe 
		        links += link_to 'Delete',admin_advertisement_path(advertisement), method: :delete,:data => { :confirm => 'Are you sure, you want to delete this advertisement?' }
	      	end
	    end
    end

    collection_action :status, method: :post do
      advertisement = Advertisement.find(params[:advertisement_id]) 
      if advertisement.status == false
         advertisement.update_attributes(:status=> !advertisement.status)
         redirect_to  admin_advertisements_path
      else
         advertisement.update_attributes(:status=> !advertisement.status)
         redirect_to  admin_advertisements_path
      end
    end

    collection_action :uppriority, method: :post do
        advertisement = Advertisement.find(params[:advertisement_id]) 
        advertisement.decrement(:priority)
		advertisement.save
		# ads = Advertisement.all.order("priority asc")
		# ads.each_with_index do |k,v|
  # 			if advertisement.eql?(k.id)
  #    			k.update_attributes(priority: k.priority-1)
  #   			# ads[v-1].update_attributes(priority: ads[v-1].priority+1)
  #   		end
  #   	end
		redirect_to  admin_advertisements_path

    end

     collection_action :downpriority, method: :post do
      advertisement = Advertisement.find(params[:advertisement_id]) 
		advertisement.increment(:priority)
		advertisement.save
		# if advertisement.priority.eql?
		redirect_to  admin_advertisements_path

    end

	show :title=> "Advertisement Details" do
	    attributes_table do
	      row :id
	      row :title
	      row :user_id
	      row :image do |img|
	        img.image.nil? ? "N/A" : image_tag(img.image.url, :size => "320x240", :controls=> true,:fallback_image => "Your browser does not support HTML5 image tags")
	      end
	      row :discription
	      row :created_at 
	      row :updated_at
	    end 
	end
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
	form do |f|
	    f.inputs "Advertisement" do
	      f.input :user
	      f.input :title
	      f.input :image
	      f.input :discription
	      f.input :priority
	    end
	    f.actions
	end

end
