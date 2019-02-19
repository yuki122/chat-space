class MessagesController < ApplicationController
  before_action :set_group, only: [:create, :index]

  def index
    @groups = current_user.groups
    set_messages
    @message = Message.new
    respond_to do |format|
      format.html
      format.json {
        # 新しく追加されたもののみ取得
        if params[:last_message_id]
          @messages = @messages.where("id > ?", params[:last_message_id])
        end
      }
    end
  end

  def create
    @message = Message.new(message_params)
    @message.group = @group
    if @message.save
      respond_to do |format|
        format.html {redirect_to group_messages_path(@group), notice: "メッセージが送信されました"}
        format.json
      end
    else
      respond_to do |format|
        format.html {
          # renderのためにインスタンス変数を用意する必要
          # @groups = current_user.groups
          # set_messages
          # flash.now[:alert] = "メッセージを入力して下さい"
          # render :index

          # flexboxがrenderだとなぜか効かないので、一旦redirectに
          redirect_to group_messages_path(@group), alert: "メッセージを入力して下さい"
        }
        format.json {render json: {alert: "メッセージを入力して下さい"}}
      end
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
