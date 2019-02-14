require "rails_helper"

describe Message do
  describe "#create" do
    context "can save" do
      it "is valid with a body and an image" do
        message = FactoryGirl.build(:message)
        expect(message).to be_valid
      end
      it "is valid with a body" do
        message = FactoryGirl.build(:message, image: "")
        expect(message).to be_valid
      end
      it "is valid with a body and an image" do
        message = FactoryGirl.build(:message, body: "")
        expect(message).to be_valid
      end
    end

    context "can not save" do
      it "is invalid without a body and an image" do
        message = FactoryGirl.build(:message, body: "", image: "")
        message.valid?
        expect(message.errors[:body]).to include "を入力してください"
      end
      it "is invalid without a group_id" do
        message = FactoryGirl.build(:message, group_id: nil)
        message.valid?
        expect(message.errors[:group]).to include "を入力してください"
      end
      it "is invalid without a user_id" do
        message = FactoryGirl.build(:message, user_id: nil)
        message.valid?
        expect(message.errors[:user]).to include "を入力してください"
      end
    end
  end
end
