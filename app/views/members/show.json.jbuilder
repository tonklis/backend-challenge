json.extract! @member, :id, :first_name, :last_name, :url, :short_url
json.topics(@member.topics) do |topic|
  json.extract! topic, :name
end
bidirectional_friends = @member.friends + @member.extended_friends
json.friends(bidirectional_friends) do |friend|
  json.extract! friend, :first_name, :last_name, :short_url
end
