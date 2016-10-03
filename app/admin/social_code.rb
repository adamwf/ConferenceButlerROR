ActiveAdmin.register SocialCode do
  	menu parent: "Social Profiles"

	batch_action :destroy, false
	actions :all, :except => [:new, :destroy, :edit]

	filter :user
    
	index do
		selectable_column
		# column :id 
		column "User Name" do |user|
     	 User.find_by(id: user.user_id) || "Created by Handel QR" 
    	end
		column "QR Code" do |code|
	      image_tag(code.image,:width => 50, :height => 50)
	    end
	    # column :code
	    column :created_at
	    column :updated_at
	    column "Actions" do |code|
	      links = ''.html_safe
	      a do
         	links += link_to 'View',admin_social_code_path(code) 
          	links += '&nbsp;&nbsp;'.html_safe
          # links += link_to 'Edit',edit_admin_user_path(user)
          # links += '&nbsp;&nbsp;'.html_safe 
          # links += link_to 'Delete',admin_user_path(user), method: :delete,:data => { :confirm => 'Are you sure, you want to delete this User?' }
      		end
		end
	end

	show :title=> "Social Code Details" do
	    attributes_table do
	      row :id
	      row :user_id
	      row :image do |code|
	        code.image.nil? ? "N/A" : image_tag(code.image, :size => "300x250", :controls=> true,:fallback_image => "Your browser does not support HTML5 image tags")
	      end
	      row :code
	      row :created_at 
	      row :updated_at
	      row 'Social Logins' do
	      	@social = User.find_by_id(social_code.user_id)
	      	@social.social_logins.map{|x|x.provider+"-"+x.user_name}.join(',')
	      end
	    end 
	end
	action_item :view, only: :show do
    	link_to 'Back',admin_social_codes_path
  	end
end
