class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      # クラスはそれぞれ<クラス>_idという外部キー（foreign_key）を持つ。この場合、railsはuser_id属性とuserクラスの外部キーを自動的に関連付ける。
      t.integer :user_id

      t.timestamps
    end
    # user idに関連付けられたすべてのマイクロポストを作成時刻の逆順で取り出すためにインデックスを付与
    add_index :microposts, [:user_id, :created_at]
  end
end
