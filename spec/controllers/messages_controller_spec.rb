require "rails_helper"

describe MessagesController do
  let(:user) { create(:user) }
  let(:group) { create(:group, users: [user]) }
  describe "GET #index" do
    context "without logged in user" do
      before do
        get :index, params: {group_id: group.id}
      end
      it { is_expected.to redirect_to new_user_session_path }
    end
    context "with logged in user" do
      before do
        login user
        get :index, params: {group_id: group.id}
      end
      it { is_expected.to render_template :index }
      it "has @groups" do
        expect(assigns(:groups)).to match [group]
      end
      it "has @group" do
        expect(assigns(:group)).to eq group
      end
      context "with messages" do
        let!(:messages) { (0..3).map { create(:message, user: user, group: group) } }
        it "has @messages" do
          sorted = messages.sort {|l, r| l.created_at <=> r.created_at}
          expect(assigns(:messages)).to match sorted
        end
      end
    end
  end

  describe "POST #create" do
    let(:post_params) {{message: attributes_for(:message), group_id: group.id}}
    context "without logged in user" do
      before do
        post :create, params: post_params
      end
      it { is_expected.to redirect_to new_user_session_path }
    end
    context "with logged in user" do
      before do
        login user
      end
      context "with valid params" do
        it "is redirected to index" do
          post :create, params: post_params
          is_expected.to redirect_to group_messages_path(group_id: group.id)
        end
        it "saves message in db" do
          expect {post :create, params: post_params}.to change {Message.count }.by(1)
        end
      end
      context "with invalid params" do
        let(:post_params) {{message: attributes_for(:message, body: "", image: nil), group_id: group.id}}
        # TODO: controllerをrenderで実装したら有効化
        # it "is render index template" do
        #   post :create, params: post_params
        #   is_expected.to render_template :index
        # end
        it "does not save message in db" do
          expect {post :create, params: post_params}.to change {Message.count }.by(0)
        end
      end
    end
  end
end
