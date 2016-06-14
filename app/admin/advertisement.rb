ActiveAdmin.register Advertisement do
	
	batch_action :destroy, false
  	config.sort_order = 'priority_asc'
	
	permit_params :image, :user_id, :title, :discription, :priority


  	scope :all, default: true
  	scope("Shown") { |ads| ads.where(status: true) }
  	scope("Hiden") { |ads| ads.where(status: false) }

  	filter :user
  	filter :title

	index do
		selectable_column
		column :id 
		# column "User Name" do |user|
  #    	 User.where(id: user.user_id).map(&:user_name) || "Created by Handel QR" 
  #   	end
		column :title
		column "Image" do |add|
	      image_tag(add.image.url,:width => 50, :height => 50)
	    end
	    column "Description" do |body|
        	truncate(body.discription, omision: "...", length: 50)
      	end
	    # column :priority, sortable: :priority
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
		unless advertisement.priority === 1
			ads = Advertisement.all.order("priority asc")
			ads.each_with_index do |k,v|
	  			if advertisement.eql?(k)
	     			k.update_attributes(priority: k.priority-1)
	    			ads[v-1].update_attributes(priority: ads[v-1].priority+1)
	    		end
	    	end
    	end
		redirect_to  admin_advertisements_path
    end

    collection_action :downpriority, method: :post do
		advertisement = Advertisement.find(params[:advertisement_id]) 
		unless advertisement.priority == Advertisement.pluck(:priority).max
			ads = Advertisement.all.order("priority asc")
			ads.each_with_index do |k,v|
	  			if advertisement.eql?(k)
	     			k.update_attributes(priority: k.priority+1)
	    			ads[v+1].update_attributes(priority: ads[v+1].priority-1)
	    		end
	    	end
    	end
		redirect_to  admin_advertisements_path
    end

	show :title=> "Advertisement Details" do
	    attributes_table do
	      row :id
	      row :title
	      row :user_id do |user|
	      	user.user_id.nil? ? "Created by Conference-Butler" : User.find_by(id: user.user_id).email
	      end
	      row :image do |img|
	        img.image.nil? ? "N/A" : image_tag(img.image.url, :size => "320x240", :controls=> true,:fallback_image => "Your browser does not support HTML5 image tags")
	      end
	      row 'Description' do
        	advertisement.discription
      	  end
	      row :created_at 
	      row :updated_at
	    end 
	end

	form do |f|
	    f.inputs "Advertisement" do
	      f.input :user, :as => :select, :collection => User.where(role: ['manager', "organizer"])
	      f.input :title
	      f.input :image

	      f.input :discription, label: "Description"
	      f.input :priority, placeholder: "Ex. 1..10"
	    end
	    f.actions
	end


	# controller do
	#     def create
	#     	ads = Advertisement.all.order("priority desc")
	#     	ads.each do |x|
	#     		p "-==-=-=-=-=-=-#{params[:advertisement][:priority].inspect}=-=-=-=-=-=-=-=-=-"
	#     		p "-------------#{x.priority}---------------"
	# 	    	if x.priority.to_s >= params[:advertisement][:priority]
	# 			    if x.priority.eql? params[:advertisement][:priority]
	# 			        x.update_attributes(priority: x.priority+1)
	# 			        p x.priority, "shahshshsh"
	# 			        super
	# 			    else
	# 			        x.update_attributes(priority: x.priority+1)
	# 			     	p x.priority
	# 			    end
	# 	    	end
	# 	    end
	# 	    redirect_to  admin_advertisements_path
	#     end
	# end

	action_item :view, only: :show do
    	link_to 'Back',admin_advertisements_path
  	end
end
