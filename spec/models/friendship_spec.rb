require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let!(:member_01){ create(:member, first_name: 'Ao') }
  let!(:member_02){ create(:member, first_name: 'Bo') }
  let!(:member_03){ create(:member, first_name: 'Co') }

  context 'creation scenario' do
    it 'should check uniqueness ' do
      friendship_01 = Friendship.create(member: member_01, friend: member_02)

      expect(Friendship.count).to eq 1
      expect(friendship_01.member).to be member_01
      expect(friendship_01.friend).to be member_02

      # shouldn't allow duplicated friendships
      dup_friendship_01 = Friendship.create(member: member_01, friend: member_02)
      dup_friendship_02 = Friendship.create(member: member_02, friend: member_01)
      expect(Friendship.count).to eq 1
    end
  end

  context 'associations and bidireccionality' do
    let!(:friendship_01){ create(:friendship, member: member_01, friend: member_02) }
    let!(:friendship_02){ create(:friendship, member: member_03, friend: member_01) }

    it 'should check associations' do
      expect(member_01.friendships.count).to eq 1
      expect(member_01.extended_friendships.count).to eq 1
    end
  end
end
