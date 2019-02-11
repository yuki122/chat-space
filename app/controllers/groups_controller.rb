class GroupsController < ApplicationController
  def index
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to group_messages_path(@group)
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  protected
  def group_params
    params.require(:group).permit(:name)
  end
end
