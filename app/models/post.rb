class Post < ApplicationRecord
  belongs_to :user
  attachment :image

  # バリデーション、空白の投稿を全て弾きたい、presenceを使う
  # title,body,imageが空の投稿を弾く
  with_options presence: true do
    validates :title
    validates :body
    validates :image
  end
end
