class Relationship < ActiveRecord::Base
	# :follower、:followedにuserクラスを提供し、:follower_id、:followed_idキーをuserモデルと関連付ける。
	# 更に、フォロワーとフォローされているユーザ両方にrelationshipを所属させる。
	belongs_to :follower, class_name: "User"
	belongs_to :followed, class_name: "User"
	validates :follower_id, presence: true
	validates :followed_id, presence: true
end
