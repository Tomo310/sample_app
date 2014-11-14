class Micropost < ActiveRecord::Base
	# userとの関連付け
	belongs_to :user
	# '-> { "ブロック" }' はラムダとかprocとか呼ばれる構文らしい。 'DESC'は新しいものから古いものへの降順。
	default_scope -> { order('created_at DESC') }
	# userの:emailや:passwordの条件付けでも使用したオプション。
	validates :content, presence: true, length: { maximum: 140 }
	# user_id属性が付与されている状態で初めて有効となる
	validates :user_id, presence: true

	def self.from_users_followed_by(user)
		# followed_user_idsメソッドは、mapメソッドの機能と同等のもの。
		# has_many :followed usersの関連付けからActive Recordが自動生成したメソッド。
		# followed_user_ids = user.followed_user_ids
		followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
		where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", followed_user_ids: followed_user_ids, user_id: user)
	end
end
