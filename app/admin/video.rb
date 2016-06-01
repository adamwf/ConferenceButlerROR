ActiveAdmin.register Video do
config.batch_actions = true
batch_action :destroy, false
  menu :label => "Videos"
  permit_params :content, :user_id, :title, :discription
  
  index do
    selectable_column
    column :id
    column :title
    column "User Name" do |user|
      User.where(id: user.user_id).map(&:user_name) || "Created by Handel QR" 
    end
    column "Video" do |video|
      video.content.nil? ? "N/A" : video_tag(video.content, :size => "120x120",:controls => true,:fallback_content => "Your browser does not support HTML5 video tags") 
    end
    column :discription
    column :created_at
    column :updated_at
    column "Status" do |video|
      video.status ? '<i class = "status_tag yes"> Show </i>'.html_safe : '<i class = "status_tag no"> Hide </i>'.html_safe 
    end
    # actions
    column "Actions" do |video|
      links = ''.html_safe
      a do
        if (current_admin_user.role == 'super-admin')
          if video.status?
           links += link_to 'Hide',status_admin_videos_path(:video_id => video), method: :post,:data => { :confirm => 'Are you sure, you want to Hide this video?' }
           links += '&nbsp;&nbsp;'.html_safe
          else  
           links += link_to 'Show',status_admin_videos_path(:video_id => video), method: :post,:data => { :confirm => 'Are you sure, you want to Show this video?' }
           links += '&nbsp;&nbsp;'.html_safe
          end
        end
        links += link_to 'View',admin_video_path(video) 
        links += '&nbsp;&nbsp;'.html_safe
        links += link_to 'Edit',edit_admin_video_path(video)
        links += '&nbsp;&nbsp;'.html_safe 
        links += link_to 'Delete',admin_video_path(video), method: :delete,:data => { :confirm => 'Are you sure, you want to delete this video?' }
      end
    end
  end
  collection_action :status, method: :post do
      video = Video.find(params[:video_id]) 
      if video.status == false
         video.update_attributes(:status=> !video.status)
         redirect_to  admin_videos_path
      else
         video.update_attributes(:status=> !video.status)
         redirect_to  admin_videos_path
      end
    end
  show :title=> "Video Details" do
    attributes_table do
      row :id
      row :title
      row :user_id
      row :discription
      row :created_at 
      row :content do |video|
        video.content.nil? ? "N/A" : video_tag(video.content, :size => "320x240", :controls=> true,:fallback_content => "Your browser does not support HTML5 video tags")
      end
    end 
  end

  form do |f|
    f.inputs "Video" do
      f.input :title
      f.input :user
      f.input :content
      f.input :discription
    end
    f.actions
  end

  action_item :view, only: :show do
    link_to 'Back',admin_videos_path
  end


  

end