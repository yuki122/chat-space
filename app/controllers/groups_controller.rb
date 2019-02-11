class GroupsController < ApplicationController
  def index
    @groups = current_user.groups
  end

  def new
    @group = Group.new
    # チェックボックスデフォルト作成のめ
    @group.user_ids = [current_user.id]
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to url_after_create_or_update, notice: "グループを作成しました。"
    else
      render :new
    end
  end

  def edit
    set_group
  end

  def update
    set_group
    if @group.update(group_params)
      redirect_to url_after_create_or_update, notice: "グループを変更しました。"
    else
      render :edit
    end
  end

  protected
  def group_params
    params.require(:group).permit(:name, {user_ids: []})
  end

  def set_group
    @group = Group.find(params[:id])
  end

  def url_after_create_or_update
    if @group.users.exists?(current_user.id)
      # group_idにマッチするpathもインスタンスから推定可能
      group_messages_url(@group)
    else
      root_url
    end
  end
end
