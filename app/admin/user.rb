ActiveAdmin.register User do
  batch_action :destroy, false
  actions :all, :except => [ :destroy]

  filter :user_name_cont , :as => :string , :label => "User Name"
  filter :first_name_cont , :as => :string , :label => "First Name"
  filter :last_name_cont , :as => :string , :label => "Last Name"
  filter :email_cont , :as => :string , :label => "Email"
  
  permit_params :email, :password, :password_confirmation, :role, :status, :tc_accept, :user_name, :address,:image

  scope :all, default: true
  scope("Active") { |user| user.where(status: true) }
  scope("Deactive") { |user| user.where(status: false) }
  scope("User") { |user| user.where(role: "user") }
  scope("Manager") { |user| user.where(role: "manager") }
  scope("Organiser") { |user| user.where(role: "organiser") }
  scope("Employee") { |user| user.where(role: "employee") }
  scope("Attendee") { |user| user.where(role: "attendee") }
  

  index :title => proc { "Total Users : #{User.count}" }  do
    selectable_column
    # column :id
    column :email
    column :user_name
    column :first_name
    column :last_name
    column :role
    column "Image" do |user|
      image_tag(user.image.url,:width => 50, :height => 50)
    end
    column :address
    # column :created_at
    # column :updated_at
    column "Status" do |user|
      user.status ? '<i class = "status_tag yes"> Active </i>'.html_safe : '<i class = "status_tag no"> Deactive </i>'.html_safe 
    end
    column "Actions" do |user|
      links = ''.html_safe
      a do
        if (current_admin_user.role == 'super-admin')
          if user.status?
           links += link_to 'Deactive',status_admin_users_path(:user_id => user), method: :post,:data => { :confirm => 'Are you sure, you want to Deactive this User?' }
           links += '&nbsp;&nbsp;'.html_safe
          else  
           links += link_to 'Active',status_admin_users_path(:user_id => user), method: :post,:data => { :confirm => 'Are you sure, you want to Active this User?' }
           links += '&nbsp;&nbsp;'.html_safe
          end
        end
        links += link_to 'View',admin_user_path(user) 
        links += '&nbsp;&nbsp;'.html_safe
        links += link_to 'Edit',edit_admin_user_path(user)
        # links += '&nbsp;&nbsp;'.html_safe 
        # links += link_to 'Delete',admin_user_path(user), method: :delete,:data => { :confirm => 'Are you sure, you want to delete this User?' }
      end
    end
  end

  collection_action :status, method: :post do
    user = User.find(params[:user_id]) 
    if user.status == false
       user.update_attributes!(:status=> true)
       redirect_to  admin_users_path
    else
       user.update_attributes!(:status=> false)
       redirect_to  admin_users_path
    end
  end

  form do |f|
    f.inputs "User" do
      f.input :email
      f.input :user_name
      f.input :password
      f.input :password_confirmation
      f.input :tc_accept
      f.input :address
      f.input :role, :as => :select, :collection =>['organizer', 'manager'] 
      f.input :image
    end
    f.actions
  end

  show :title=> "User Details" do
    attributes_table do
      row :id
      row :user_name
      row :first_name
      row :last_name
      row :email
      row :address          
      row :image do |user|
        user.image.nil? ? "N/A" : image_tag(user.image.url, :size => "320x240", :controls=> true,:fallback_image => "Your browser does not support HTML5 image tags")
      end
      row :role
      row :tc_accept
      row :created_at 
      row :updated_at
      row 'Social Code' do
      user.social_code.nil? ? "N/A" : image_tag(user.social_code.image)
      end
      row 'Social Logins' do
      user.social_logins.present? ? user.social_logins.map{|x|x.provider+"-"+x.user_name}.join(', ') : "N/A"
      end
    end 
  end
  action_item :view, only: :show do
    link_to 'Back',admin_users_path
  end
end
