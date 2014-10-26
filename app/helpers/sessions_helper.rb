module SessionsHelper

#	コントローラ、ビューの両方からアクセスできるcurrent_userを作成する。
	def sign_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token # 20年後に期限切れするクッキーを作成(まあ半永久的でしょってことでpermanent)。
#		cookies[:remember_token] = { value: remember_token, expires: 20.years.from_now.utc } <= これと上が同義
		user.update_attribute(:remember_token, User.encrypt(remember_token))
#		メソッド内でselfを使うと、そのメソッドを使用しているオブジェクトを呼び出すことができる。
#		sign_inはsessionコントローラのcreateアクション中のpublicメソッドとして呼び出されるため、current_user=()によって作成される@current_userは、
#		publicなインスタンス変数として扱われる（アプリケーション内のどこからでもアクセス可能ということ）。
		self.current_user = user   # 下記の定義通り、userは引数扱い（のはず）。この定義がないと、self.current_userが未知のオブジェクト（？）として扱われてエラーになると思われる。
	end

#	current_userが設定されているかどうか（すなわち当該ユーザがログインしているかどうか）を確認
	def signed_in?
		!current_user.nil?
	end

#	インスタンス変数@current_userを設定するためのメソッドというか、手続き。引数userを代入。
	def current_user=(user)
		@current_user = user
	end

#	上記のcurrent_user=()はインスタンス変数とsign_inメソッドへの引用を兼ねたもの。
#	こちらはsign_inメソッドによって作成されたremember_tokenを利用して、ログイン状態を維持するためのメソッド（多分）。
#	これがcurrent_userメソッドの実体らしく、これが無いとsign_inメソッドが動かない。
	def current_user
		remember_token = User.encrypt(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)	# 変数@current_userに右辺を代入する(@current_user == nilならば)、orしない。
		# @current_user = @current_user || User.find_by(remember_token: remember_token)と上は同義
		# 上記の処理は、左側(@current_user)の値がtrueであれば(nilとfalse以外はtrue扱い)、その時点で終了する。これを短絡評価とかいうらしい
	end

	def current_user?(user)
		user == current_user
	end

#	@current_userをnilにして、coolieに記録されたtokenを削除
	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	# アプリ側からのサインイン要求にユーザが応えた場合、ユーザが本来要求したURLにリダイレクトしてあげるために、セッション機能に要求されたURLを格納しておく
	def store_location
		session[:return_to] = request.url
	end
end