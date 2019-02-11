class GroupsController < ApplicationController
  def index
  end

  def new
    @group = Group.new
    # チェックボックスデフォルト作成のめ
    @group.user_ids = [current_user.id]
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      # group_idにマッチするpathもインスタンスから推定
      redirect_to group_messages_path(@group), notice: "グループを作成しました。"
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
    params.require(:group).permit(:name, {user_ids: []})
  end
end
