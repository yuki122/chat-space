class MessagesController < ApplicationController
  before_action :set_group, only: [:create, :index]

  def index
    @groups = current_user.groups
    set_messages
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.group = @group
    if @message.save
      redirect_to group_messages_path(@group), notice: "メッセージが送信されました"
    else
      # renderのためにインスタンス変数を用意する必要
      # @groups = current_user.groups
      # set_messages
      # flash.now[:alert] = "メッセージを入力して下さい"
      # render :index

      # flexboxがrenderだとなぜか効かないので、一旦redirectに
      redirect_to group_messages_path(@group), alert: "メッセージを入力して下さい"
    end
  end

  protected
  def message_params
    params.require(:message).permit([:body, :image]).merge(user_id: current_user.id)
  end
  def set_group
    @group = Group.find(params[:group_id])
  end
  def set_messages
    @messages = @group.messages.includes(:user).order("created_at")
  end
end
