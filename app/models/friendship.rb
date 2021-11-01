class Friendship < ApplicationRecord
  belongs_to :member
  belongs_to :friend, class_name: 'Member'

  validates :member, uniqueness: { scope: :friend }
  validate :check_bidirection

  private

  def check_bidirection
    previous_friendship = Friendship.find_by(member: friend, friend: member)
    errors.add(:friendship_exists, "Friendship already exists") if previous_friendship
  end
end
