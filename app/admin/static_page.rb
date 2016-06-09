ActiveAdmin.register StaticPage do
batch_action :destroy, false
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :content
#
  filter :title

# or
 	index do 
		selectable_column
		column :id
		column :title
		column "Content" do |body|
      		truncate(body.content, omision: "...", length: 50)
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
