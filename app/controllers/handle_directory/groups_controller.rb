class HandleDirectory::GroupsController < HandleDirectory::BaseController
  before_filter :require_handle_user
  before_action :set_group, only: [:edit, :update, :destroy]

  def index
    group_created = current_handle_user.groups
    group_joined = Group.where(id: GroupMembership.where(user_id: current_handle_user.id).pluck(:group_id))
    @groups =  (group_created + group_joined).uniq
  end

  def show
     @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create    
    members = User.find(params[:group][:member_ids])
    @group = current_handle_user.groups.new(group_params)
    respond_to do |format|
      if @group.save
        members.each do |member|
          p"=-=-=-=-=-#{(member.id).inspect}=-=-=-=-"
          group = @group.group_memberships.create!(user_id: member.id)
        end
        format.html { redirect_to [:handle_directory, @group], notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to [:handle_directory, @group], notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def mute
    @group = Group.find(params[:id])
    member = current_handle_user.group_memberships.find_by(group_id: params[:id])   
    respond_to do |format|
      if member
        member.update_attribute(:is_mute,true)
        format.html { redirect_to handle_directory_group_path(@group), notice: 'Group was successfully muted.' }
      else
        format.html { redirect_to handle_directory_group_path(@group), alert: 'There is some issues while updating group.' }
      end
    end
  end
  
  def unmute
    @group = Group.find(params[:id])
    member = current_handle_user.group_memberships.find_by(group_id: params[:id])   
    respond_to do |format|
      if member
        member.update_attribute(:is_mute,false)
        format.html { redirect_to handle_directory_group_path(@group), notice: 'Group was successfully un-muted.' }
      else
        format.html { redirect_to handle_directory_group_path(@group), alert: 'There is some issues while updating group.' }
      end
    end
  end


  def destroy
    if @group.present?
      @group.destroy
      flash[:notice] = "Group deleted successfully."
    else
      @membership = GroupMembership.find_by(group_id: params[:id],user_id: current_handle_user.id)
      if @membership.present?
         @membership.destroy
         flash[:notice] = "Leaved Group successfully."
      end
    end
    redirect_to handle_directory_groups_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find_by(id: params[:id],user_id: current_handle_user.id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:group_name, :user_id, :group_image)
    end
end

