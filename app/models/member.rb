class Member < ApplicationRecord
  has_many :topics, dependent: :destroy
  has_many :friendships
  has_many :extended_friendships, foreign_key: "friend_id", class_name: "Friendship"
end
