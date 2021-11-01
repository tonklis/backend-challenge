Topic.destroy_all
Friendship.destroy_all
Member.destroy_all

puts "Creating members"
member_01 = Member.create!(
  first_name: "a",
  last_name: "A",
  url: "abc.dummy.url"
)
Topic.create!(name: "Secrets of Europe", member: member_01)
Topic.create!(name: "Secrets of Africa", member: member_01)

member_02 = Member.create!(
  first_name: "b",
  last_name: "B",
  url: "abc.dummy.url"
)

Topic.create!(name: "F1 in Europe", member: member_02)
Topic.create!(name: "F1 in Africa", member: member_02)

member_03 = Member.create!(
  first_name: "c",
  last_name: "C",
  url: "abc.dummy.url"
)

Topic.create!(name: "Football in Europe", member: member_03)
Topic.create!(name: "Football in Africa", member: member_03)

member_04 = Member.create!(
  first_name: "d",
  last_name: "D",
  url: "abc.dummy.url"
)

Topic.create!(name: "Soccer in Europe", member: member_04)
Topic.create!(name: "Soccer in Africa", member: member_04)

member_05 = Member.create!(
  first_name: "e",
  last_name: "E",
  url: "abc.dummy.url"
)

Topic.create!(name: "Water in Europe", member: member_05)
Topic.create!(name: "Water in Africa", member: member_05)

member_06 = Member.create!(
  first_name: "f",
  last_name: "F",
  url: "abc.dummy.url"
)

Topic.create!(name: "Money in Europe", member: member_06)
Topic.create!(name: "Cash in Africa", member: member_06)

puts "Creating friendships"

Friendship.create!(member: member_01, friend: member_02)
Friendship.create!(member: member_03, friend: member_02)
Friendship.create!(member: member_04, friend: member_03)

Friendship.create!(member: member_04, friend: member_05)
Friendship.create!(member: member_05, friend: member_01)
Friendship.create!(member: member_06, friend: member_05)
