class Micropost < ActiveRecord::Base
	# userとの関連付け
	belongs_to :user
	# '-> { "ブロック" }' はラムダとかprocとか呼ばれる構文らしい。 'DESC'は新しいものから古いものへの降順。
	default_scope -> { order('created_at DESC') }
	# userの:emailや:passwordの条件付けでも使用したオプション。
	validates :content, presence: true, length: { maximum: 140 }
	# user_id属性が付与されている状態で初めて有効となる
	validates :user_id, presence: true
end
