ActiveAdmin.register Post do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
 	permit_params :content, :user_id, :title
# or
	index do 
		selectable_column
		column :id
		column :title
		column :content
		column "User Name" do |user|
	      User.where(id: user.user_id).map(&:user_name) || "Created by Handel QR" 
	    end
	    column :created_at
    	column :updated_at
	    actions
	end
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


end
