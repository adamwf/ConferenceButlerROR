ActiveAdmin.register Event do
 batch_action :destroy, false

	permit_params :name, :start_time, :end_time, :category, :location, :event_type, :no_of_availability, :availability, :user_id
	
	filter :name_cont , :as => :string , :label => "Event Name"
  	filter :start_time  , :label => "Event Start Date & Time"
  	filter :end_time  , :label => "Event End Date & Time"
  	filter :user_id, :as => :select, :collection => User.where(role: "organizer").map(&:user_name)
	
	index :title => proc { "Total Events : #{Event.count}" }  do
	    selectable_column
	    # column :id
	    column :name
	    column :location
	    column :start_time
	    column :end_time
	    column :category
	    column :availability
	    column "Actions" do |event|
	      links = ''.html_safe
		    a do
		        links += link_to 'View',admin_event_path(event) 
		        links += '&nbsp;&nbsp;'.html_safe
		        links += link_to 'Edit',edit_admin_event_path(event)
		        links += '&nbsp;&nbsp;'.html_safe 
		        links += link_to 'Delete',admin_event_path(event), method: :delete,:data => { :confirm => 'Are you sure, you want to delete this event?' }
		    end
	    end
    end


	form do |f|
	    f.inputs "Event" do
	      f.input :category, label: "Category"
	      f.input :name
	      f.input :location
	      f.input :start_time,  as: :date_time_picker, datepicker_options: { min_date: Time.current }
	      f.input :end_time,  as: :date_time_picker, datepicker_options: { min_date: Time.current}
	      f.input :event_type, :as => :select, :collection => ["Without Signup", "With Signup"], include_blank: false #,:input_html => { :disabled => true }
	      f.input :no_of_availability,label: "Number of Availability"
	      f.input :user_id, :as => :select, :collection => User.where(role: "organizer")#.map(&:user_name)
	    end
	    f.actions
	end

	show :title=> "Event Details" do
	    attributes_table do
	      row :id
	      row :name
	      row :location
	      row :start_time
	      row :end_time
	      row :category          
	      row "User" do
	        User.find_by(id: event.user_id).user_name
	      end
	      row :availability
	      row :created_at 
	      row :updated_at
	    end 
	end
  
	action_item :view, only: :show do
	    link_to 'Back',admin_users_path
	end

end
