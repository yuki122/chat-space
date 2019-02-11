class MessagesController < ApplicationController
  def index
    @groups = current_user.groups
    @group = Group.find(params[:group_id])
    # TODO: N+1問題について要検討
    @messages = @group.messages.order("created_at")
  end

  def create
  end
end
