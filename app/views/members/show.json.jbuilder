json.extract! @member, :id, :first_name, :last_name, :url, :short_url
json.topics(@member.topics) do |topic|
  json.extract! topic, :name
end
bidirectional_friendships = @member.friendships + @member.extended_friendships
json.friendships(bidirectional_friendships) do |friendship|
  json.extract! friendship.member, :short_url
end
