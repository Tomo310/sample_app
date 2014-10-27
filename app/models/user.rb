class User < ActiveRecord::Base
	# マイクロポストを複数所有する関連付け。あるuserが破棄された場合、関連するmicropostも破棄される（dependent: :destroy）。
	has_many :microposts, dependent: :destroy
	has_secure_password
	before_save { email.downcase! }
	before_create :create_remember_token
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def feed
		# 'id'で指定したuser_idに関連しているmicropostを全て呼び出す
		Micropost.where("user_id = ?", id)
	end

	private

		def create_remember_token
#			頭にselfをつけることによって、remember_tokenがこのメソッド内のローカル変数ではなく、Userモデルのインスタンス変数になる。
#			これにより、Userをデータベースに保存する際に、remember_tokenもデータベース上に記録されるようになる。
			self.remember_token = User.encrypt(User.new_remember_token)
		end
end