ActiveAdmin.register User do
batch_action :destroy, false
filter :user_name_cont , :as => :string , :label => "Username"
filter :email_cont , :as => :string , :label => "Email"
 permit_params :email, :password, :password_confirmation, :role, :status
 
  index :title => proc { "Total users #{User.count}" }  do
    selectable_column
    column :id
    column :email
    column :user_name
    column :first_name
    column :last_name
    column :role
    # column :otp
    column :tc_accept
    column "Image" do |user|
      image_tag(user.image.url,:width => 30, :height => 30)
    end
    column :address
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs "User" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :role, :as => :select, :collection =>['organizer', 'manager'] 
     
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
        end 
  end
end
