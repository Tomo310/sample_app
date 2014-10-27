class MicropostsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy]
	before_action :correct_user, only: :destroy

=begin
	# サインインしていないユーザでもアクセス可能なアクション
	def index
	end
=end
	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			# micropost_paramがnilの場合、@micropostがnilとなり、連鎖でfeedがnilを返すようになってしまう模様。当然@feed_itemもnilとなる。
			# @feed_itemsがnilだと、_feed.html.erbの@feed_items.any?メソッドがエラーを吐いてしまう。そこで空配列を入れる。
			# 空配列を使わなくても、root_urlへのリダイレクトで何とかなるはずだけれど、その場合には_error_messageヘルパーが機能しなくなってしまう（flashでエラー表示するしかないか？）。
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		redirect_to root_url
	end

	private

		def micropost_params
			params.require(:micropost).permit(:content)
		end

		def correct_user
			@micropost = current_user.microposts.find_by(id: params[:id])
			redirect_to root_url if @micropost.nil?
		end
end