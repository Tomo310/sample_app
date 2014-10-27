require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  # 関連ユーザの情報を保持していること、関連ユーザと作成ユーザが一致していることを確認
  it { should respond_to(:user) }
  its(:user) { should eq user }

  # モデルが有効であることを確認する。
  it { should be_valid }

  # user_id属性が付与されていない場合にマイクロポストが無効となることを確認
  describe "when user_id is not present" do
  	before { @micropost.user_id = nil }
  	it { should_not be_valid }
  end

  # 内容が空白のmicropostを弾く
  describe "with blank content" do
  	before { @micropost.content = " " }
  	it { should_not be_valid }
  end

  # 字数を140字以内に限る
  describe "with content that is too long" do
  	before { @micropost.content = "a" * 141 }
  	it { should_not be_valid }
  end
end
