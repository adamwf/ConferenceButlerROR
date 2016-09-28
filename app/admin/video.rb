ActiveAdmin.register Video do
  menu parent: "Curate Feeds"

  config.batch_actions = true
  batch_action :destroy, false
 # menu :label => "Videos"
  permit_params :content, :user_id, :title, :discription, :category
  
  scope :all, default: true
  scope("Published") { |video| video.where(status: true) }
  scope("Not Published") { |video| video.where(status: false) }
  scope("Home Videos") { |video| video.where(category: "home") }
  scope("Event Videos") { |video| video.where(category: "event") }
  scope("Discover Videos") { |video| video.where(category: "discover") }
  scope("Trending Videos") { |video| video.where(category: "trending") }
  scope("Shop Videos") { |video| video.where(category: "shop") }

  filter :user
  filter :category_cont , :as => :string , :label => "Category"
  filter :title_cont , :as => :string , :label => "Video Title"
  # filter :status

  index do
    selectable_column
    # column :id
    column "Title" do |body|
      truncate(body.title, omision: "...", length: 10)
    end
    # column "User Name" do |user|
    #   User.where(id: user.user_id).map(&:user_name) || "Created by Handel QR" 
    # end
    column "Video" do |video|
      video.content.nil? ? "N/A" : video_tag(video.content, :size => "250x150",:controls => true,:fallback_content => "Your browser does not support HTML5 video tags") 
    end
    column "Description" do |body|
      truncate(body.discription, omision: "...", length: 50)
    end
    # column :created_at
    # column :updated_at
    column :category
    column "Status" do |video|
      video.status ? '<i class = "status_tag yes"> Published </i>'.html_safe : '<i class = "status_tag no"> Do Not Published </i>'.html_safe 
    end
    # actions
    column "Actions" do |video|
      links = ''.html_safe
      a do
        if (current_admin_user.role == 'super-admin')
          if video.status?
           links += link_to 'Do Not Published',status_admin_videos_path(:video_id => video), method: :post,:data => { :confirm => 'Are you sure, you want to Hide this video?' }
           links += '&nbsp;&nbsp;'.html_safe
          else  
           links += link_to 'Published',status_admin_videos_path(:video_id => video), method: :post,:data => { :confirm => 'Are you sure, you want to Show this video?' }
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
      row :category
      row "Description" do |video|
        video.discription
      end
      row :created_at 
      row :updated_at
      row :content do |video|
        video.content.nil? ? "N/A" : video_tag(video.content, :size => "400x250", :controls=> true,:fallback_content => "Your browser does not support HTML5 video tags")
      end
    end 
  end

  form do |f|
    f.inputs "Video" do
      f.input :title
      f.input :user, :as => :select, :collection => User.where(role: ['manager', "organizer"])
      f.input :content
      f.input :category, :as => :select, :collection =>  ['home', "event", 'feeds', 'discover','shop', 'trending']
      f.input :discription, label: "Description"
    end
    f.actions
  end
  action_item :view, only: :show do
    link_to 'Back',admin_videos_path
  end
end