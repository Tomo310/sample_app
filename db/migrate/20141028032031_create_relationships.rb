class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # 配列指定したキーの組み合わせの一意性を保障
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
