# ユーザアカウントの作成、編集を扱うコントローラ
class UsersController < ApplicationController
	before_action :signed_in_user, only: [:index, :edit, :update, :following, :followers]
	before_action :correct_user, only: [:edit, :update]
	before_action :admin_user, only: :destroy
	before_action :already_signed_in, only: [:new, :create]

	def index
		# ページごとの件数を指定する場合には、オプションに':per_page => "件数"を追加
		@users = User.paginate(page: params[:page])
	end

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated"
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		user = User.find(params[:id])
		if current_user? user
			redirect_to(root_path)
		else
			user.destroy
			flash[:success] = "User destroyed."
			redirect_to users_url
		end
	end

	# following/followersはどちらもほぼ同じerbを用いるため、renderするビューが同じになっている
	def following
		@title = "Following"
		@user = User.find(params[:id])
		@users = @user.followed_users.paginate(page: params[:page])
		render 'show_follow'
	end

	def followers
		@title = "Followers"
		@user = User.find(params[:id])
		@users = @user.followers.paginate(page: params[:page])
		render 'show_follow'
	end

	private

		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end

		# Before actions
		# 各アクションの前に実行されるメソッド

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end

		#:adminキーがtrueでない場合にはrootに強制送還
		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end

		# 複垢防止用のbefore_actionメソッド
		def already_signed_in
			if signed_in?
				redirect_to(root_path)
			end
		end
end