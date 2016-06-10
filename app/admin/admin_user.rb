ActiveAdmin.register AdminUser do
  menu priority: 2
  batch_action :destroy, false
  permit_params :email, :password, :password_confirmation, :role, :status
  
  index do
    selectable_column
    id_column
    column :email
    column :role
    column :current_sign_in_at
    column :sign_in_count
    column "Status" do |user|
      user.status ? '<i class = "status_tag yes"> Active </i>'.html_safe : '<i class = "status_tag no"> Deactive </i>'.html_safe 
    end
    column "Actions" do |user|
      links = ''.html_safe
      a do
        if (current_admin_user.role == 'super-admin')
          if user.status?
           links += link_to 'Deactive',status_admin_admin_users_path(:user_id => user), method: :post,:data => { :confirm => 'Are you sure, you want to Deactive this Admin User?' }
           links += '&nbsp;&nbsp;'.html_safe
          else  
           links += link_to 'Active',status_admin_admin_users_path(:user_id => user), method: :post,:data => { :confirm => 'Are you sure, you want to Active this Admin User?' }
           links += '&nbsp;&nbsp;'.html_safe
          end
        end
        links += link_to 'View',admin_admin_user_path(user) 
        links += '&nbsp;&nbsp;'.html_safe
        links += link_to 'Edit',edit_admin_admin_user_path(user)
        links += '&nbsp;&nbsp;'.html_safe 
        # links += link_to 'Delete',admin_admin_user_path(user), method: :delete,:data => { :confirm => 'Are you sure, you want to delete this Admin User?' }
      end
    end
    #actions
  end

  collection_action :status, method: :post do
    user = AdminUser.find(params[:user_id]) 
    if user.status == false
       user.update_attributes(:status=> !user.status)
       redirect_to  admin_admin_users_path
    else
       user.update_attributes(:status=> !user.status)
       redirect_to  admin_admin_users_path
    end
  end

  filter :email
  # filter :current_sign_in_at
  # filter :sign_in_count
  # filter :created_at

  show :title=> "Admin User Details" do
    attributes_table do
      row :id
      row :email
      row :role
      row :status
      row :created_at 
      row :updated_at
    end 
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :role, :as => :select, :collection =>['super-admin', 'corporate-user'] 
      f.input :status
    end
    f.actions
  end


  controller do
    def create
      super
      # UserMailer.account_confirmation(@admin_user).deliver_now
    end
  end

end
