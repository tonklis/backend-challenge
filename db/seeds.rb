Friendship.destroy_all
Member.destroy_all

puts "Creating members"
member_01 = Member.create!(
  first_name: "a",
  last_name: "A",
  url: "abc.dummy.url"
)

member_02 = Member.create!(
  first_name: "b",
  last_name: "B",
  url: "abc.dummy.url"
)

member_03 = Member.create!(
  first_name: "c",
  last_name: "C",
  url: "abc.dummy.url"
)

Friendship.create!(member: member_01, friend: member_02)
Friendship.create!(member: member_03, friend: member_01)
