json.array! @members do |member|
  json.extract! member, :first_name, :last_name, :short_url
  json.friends_count member.friendships.count + member.extended_friendships.count
end
