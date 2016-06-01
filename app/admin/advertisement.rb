ActiveAdmin.register Advertisement do
batch_action :destroy, false

permit_params :image, :user_id, :title, :discription
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
	index do
		selectable_column
		column :id 
		column "User Name" do |user|
     	 User.where(id: user.user_id).map(&:user_name) || "Created by Handel QR" 
    	end
		column :title
		column "Image" do |add|
	      image_tag(add.image.url,:width => 30, :height => 30)
	    end
	    column :discription
	    column :created_at
	    column :updated_at
	    actions
	end
# or
#

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
	    end
	    f.actions
	end

end
