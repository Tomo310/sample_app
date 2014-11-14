class User < ActiveRecord::Base
	# マイクロポストを複数所有する関連付け。あるuserが破棄された場合、関連するmicropostも破棄される（dependent: :destroy）。
	has_many :microposts, dependent: :destroy
	# クラスはそれぞれ<クラス>_idという外部キー（foreign_key）を持つ。micropostの場合はmicropost側にuser_idの属性が明示されているが、
	# relationshipにはそんな属性は無いので、relationshipの中の属性どれかをuserの外部キーとして指定してあげる必要がある。
	# relationshipモデル側にも、follower_idが外部キーであることを認識させる必要があるが、それはrelationship.rbを参照。
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	# follower_idを通して関連付けされたrelationshipを経由して、followed_usersを所属させるイメージ。
	# また、followed_usersの元がfollowed_idであることを明示する。
	has_many :followed_users, through: :relationships, source: :followed
	# フォローされたユーザからfollowerへアクセスするための逆リレーションシップ（reverse_relationship）をシミュレートする。
	# 実際にはrelationshipのテーブルを用いるため、クラスとして"Relationship"を指定
	has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
	# このような関連付けの場合（外部キーが関連付けの対象の単数形_idであるとき）、sourceオプションを省くことができる（ここではちゃんと明示しているけれど）。
	# 上のfollowed_usersの場合にはそういうわけにもいかない。
	has_many :followers, through: :reverse_relationships, source: :follower
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
		# 不完全版。'id'で指定したuser_idに関連しているmicropostを全て呼び出す
		# Micropost.where("user_id = ?", id)
		Micropost.from_users_followed_by(self)
	end

	# 暗にself.relationships.find_by....を表す。followerとか明示しなくても良いらしい。
	def following?(other_user)
		relationships.find_by(followed_id: other_user.id)
	end

	# 暗にself.relationships.create!(...)を表す。followerとか明示しなくてもcreateできるらしい。
	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		relationships.find_by(followed_id: other_user.id).destroy
	end

	private

		def create_remember_token
#			頭にselfをつけることによって、remember_tokenがこのメソッド内のローカル変数ではなく、Userモデルのインスタンス変数になる。
#			これにより、Userをデータベースに保存する際に、remember_tokenもデータベース上に記録されるようになる。
			self.remember_token = User.encrypt(User.new_remember_token)
		end
end