class UsersController < ApplicationController
  def index

    @users = User.where("name LIKE ?", "%#{params[:name_cont]}%").order("name")
    respond_to do |format|
      # 現状jsonのみでのアクセスを想定
      format.json
    end
  end
end
