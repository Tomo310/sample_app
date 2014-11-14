class RelationshipsController < ApplicationController
	before_action :signed_in_user

	# リクエストの種類）に応じて、続くキーの中から1つだけが実行される。
	respond_to :html, :js

	# これらのアクションの呼び出し時には、呼び出しの指令とともに:followed_idの指定を行う必要がある。xpathを用いた実装だとその辺を勝手にやってくれるっぽい？
	def create
		@user = User.find(params[:relationship][:followed_id])
		current_user.follow!(@user)
		# format（リクエストの種類）に応じて、続く行の中から1つだけが実行される。
#		respond_to do |format|
#			format.html { redirect_to @user }
			# アクションと同じ名前のJavaScript組み込みRubyを呼び出す
#			format.js
#		end
		respond_with @user
	end

	def destroy
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow!(@user)
#		respond_to do |format|
#			format.html { redirect_to @user }
#			format.js
#		end
		respond_with @user
	end
end